module SqlGroupBy
  extend ActiveSupport::Concern

  included do

    class self::GroupBy
      attr_accessor :value

      def initialize(sql)
        @value = self.process!(sql.query)
      end

      def output
        vs = value.map { |v| ":#{v}" }.join(', ')

        ".group(#{vs})"
      end

      def present?
        @value.present?
      end

      protected

      def process!(query)
        temp = query.scan(/group by\s(.*?[^,])[\s|;]/).flatten.first.to_s
        temp.split(',').map(&:strip)
      end
    end
  end
end
