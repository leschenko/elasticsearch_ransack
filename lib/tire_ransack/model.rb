module TireRansack
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
      #   example: <code>User.tire_ransack({translations_name_cont: 'text'}, globalize: true)</code>
      #   will search on 'name_en' field (depending on current locale)
      #
      # === Examples
      #   Product.tire_ransack(name_cont: 'alex', category_id_eq: 1, tag_ids_in: [2, 3])
      #   Product.tire_ransack(tag_ids_in: '2,3,4')
      #   Product.tire_ransack(created_at_gt: 1.day.ago)
      #   Product.tire_ransack(q_cont: 'table')
      #   Product.tire_ransack(s: 'price desc')
      #   Product.tire_ransack({translations_name_cont: 'chair'}, globalize: true)
      #
      def tire_ransack(options={}, search_options={})
        tire_ransack = Search.new(self, options, search_options)
        tire_ransack.search
        tire_ransack
      end
    end

  end
end