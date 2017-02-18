module SqlOffset
  extend ActiveSupport::Concern

  included do

    class self::Offset
      attr_accessor :value

      def initialize(sql)
        @value = self.process!(sql.query)
      end

      def output
        ".offset(#{value})"
      end

      def present?
        @value.present?
      end

      protected

      def process!(query)
        query.scan(/offset\s(.*?[^,])[\s|;]/i).flatten.first.to_s
      end
    end
  end
end
