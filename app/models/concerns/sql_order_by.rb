module SqlOrderBy
  extend ActiveSupport::Concern

  included do

    class self::OrderBy

      class Condition
        attr_accessor :value, :order

        def initialize(v, o)
          @value = v
          @order = o
        end
      end

      def initialize(sql)
        @all = self.process!(sql.query)
      end

      def output
        result = @all.map { |el| check_colon(el) }

        ".order(#{result.join(', ')})"
      end

      def present?
        @all.present?
      end

      protected

      def process!(query)
        order_str = "#{query} "
                        .scan(/order by\s((?:.*?(?:desc|asc)|(?:.+)(?:asc|desc)[^,]|(?:.*?)[^,]))(?:;)?\s/i)
                        .flatten
                        .first
                        .to_s.delete('][\'\"')

        tmp = order_str.split(',').map(&:strip)
        tmp.map { |c| create_new_condition(c) }
      end

      private

      def check_colon(el)
        el.order.present? ? "#{el.value}: :#{el.order}" : ":#{el.value}"
      end

      def create_new_condition(a)
        values = a.split
        Condition.new(values[0], values[1])
      end
    end
  end
end
