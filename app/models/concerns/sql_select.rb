module SqlSelect
  extend ActiveSupport::Concern

  included do

    class self::Select
      attr_accessor :value

      def initialize(sql)
        @value = self.process!(sql.query)
      end

      def all?
        @value.size == 1 && @value.first.eql?('*')
      end

      def output
        vs = value.map { |v| process_string_value(v) }.join(', ')

        ".select(#{vs})"
      end

      def present?
        @value.present?
      end

      protected

      def process!(query)
        temp = query.scan(/select\s(.*?[^,])[\s|;]/).flatten.first.to_s
        temp.split(',').map(&:strip)
      end

      private

      def process_string_value(v)
        if v.include?('.')
          "'#{v}'"
        else
          ":#{v}"
        end
      end
    end
  end
end
