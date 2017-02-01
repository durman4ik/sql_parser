module SqlLimit
  extend ActiveSupport::Concern

  included do

    class self::Limit
      attr_accessor :value

      def initialize(sql)
        @value = self.process!(sql.query)
      end

      def output
        ".limit(#{value})"
      end

      def present?
        @value.present?
      end

      protected

      def process!(query)
        query.scan(/limit\s(.*?[^,])[\s|;]/).flatten.first.to_s
      end
    end
  end
end
