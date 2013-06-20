module ElasticRansack
  module Model

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      # === options
      # [:s]
      #   sorting column
      #   can contain sort mode separated by space
      #   example: 'id desc'
      # [:q_cont]
      #   search against _all fields
      #
      # ==== condition predicates:
      #   '_cont'    contains string value
      #   '_eq'      equal value
      #   '_in'      include any of the values
      #   '_in_all'  include all values
      #   '_gt'      greater then value
      #   '_lt'      less then value
      #   '_gteq'    greater or equal the value
      #   '_lteq '   less or equal the value
      #
      # === search_options
      # [:globalize]
      #   For search on localized attributes like 'name_en' via 'translations_' prefixed field
      #   example: <code>User.elastic_ransack({translations_name_cont: 'text'}, globalize: true)</code>
      #   will search on 'name_en' field (depending on current locale)
      #
      # === Examples
      #   Product.elastic_ransack(name_cont: 'alex', category_id_eq: 1, tag_ids_in: [2, 3])
      #   Product.elastic_ransack(tag_ids_in: '2,3,4')
      #   Product.elastic_ransack(created_at_gt: 1.day.ago)
      #   Product.elastic_ransack(q_cont: 'table')
      #   Product.elastic_ransack(s: 'price desc')
      #   Product.elastic_ransack({translations_name_cont: 'chair'}, globalize: true)
      #
      def elastic_ransack(options={}, search_options={})
        elastic_ransack = Search.new(self, options, search_options)
        elastic_ransack.search
        elastic_ransack
      end
    end

  end
end