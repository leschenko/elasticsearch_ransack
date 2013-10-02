module ElasticRansack
  class Search
    include ::ElasticRansack::Naming
    include Enumerable

    attr_reader :options, :search_options, :model, :search_results, :sorts, :globalize

    delegate :results, :each, :empty?, :size, :[], to: :search_results
    delegate :total_entries, :per_page, :total_pages, :current_page, :previous_page, :next_page, :offset, :out_of_bounds?,
             to: :search_results

    alias_method :klass, :model

    DATETIME_REGEXP = /\d{2}\.\d{2}.\d{4} \d{2}\:\d{2}/
    DATE_REGEXP = /\d{2}\.\d{2}.\d{4}/

    def initialize(model, options, search_options)
      search_options ||= {}
      search_options.reverse_merge!(globalize: true)
      @model = model
      @options = options.stringify_keys
      @search_options = search_options || {}
      @sorts = []
      @globalize = @search_options.delete(:globalize)
      sorting = @options.delete('s')
      if sorting.blank?
        add_sort('_score', 'desc')
        add_sort('id', 'desc')
      else
        sorting_split = sorting.split(/\s+/, 2)
        add_sort(sorting_split[0], sorting_split[1] || 'asc')
      end
    end

    def add_sort(name, dir)
      @sorts << OpenStruct.new(name: name, dir: dir)
    end

    def search
      @search_results ||= begin
        that = self
        query_string = []
        tire.search(@search_options) do
          and_filters = []
          not_filters = []
          sort do
            that.sorts.each do |s|
              by s.name, s.dir
            end
          end

          that.options.each do |k, v|
            next if v.blank?
            v = v.to_i if ElasticRansack.integer_fields_regexp =~ k

            if k == 'q_cont' || k == 'q_eq'
              query_string << "#{v.lucene_escape}" if v.present?
              next
            end

            if k =~ /^(.+)_cont$/
              attr = $1
              attr = "#{$1.sub(/^translations_/, '')}_#{I18n.locale}" if that.globalize && attr =~ /^translations_(.+)/
              attr_query = [
                  v.split.map { |part| "#{attr}:*#{part.lucene_escape}*" }.join(' AND '),
                  v.split.map { |part| "#{attr}:\"#{part.lucene_escape}\"" }.join(' AND ')
              ]
              query_string << attr_query.map { |q| "(#{q})" }.join(' OR ')
              next
            else
              v = that.format_value(v)
            end

            ElasticRansack.predicates.each do |predicate|
              if k =~ predicate.regexp
                key = $1
                if k =~ /not/
                  not_filters << predicate.query.call(key.sub('_not', ''), v)
                else
                  and_filters << predicate.query.call(key, v)
                end
                break
              end
            end
          end

          query { string query_string.join(' ') } unless query_string.blank?
          filter(:and, filters: and_filters) unless and_filters.blank?
          not_filters.each do |filter|
            filter(:not, filter: filter)
          end
        end
      end
    end


    def translate(*args)
      model.human_attribute_name(args.first)
    end

    def format_value(v)
      if v =~ DATETIME_REGEXP
        Date.parse(v)
      elsif v =~ DATE_REGEXP
        Time.parse(v)
      else
        v
      end
    end

    def method_missing(*args, &block)
      @model.send(*args, &block)
    end
  end
end