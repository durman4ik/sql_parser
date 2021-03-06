module SqlUpdate
  extend ActiveSupport::Concern

  included do

    class self::Update
      attr_accessor :value

      def initialize(sql)
        @value = self.process!(sql.query)
      end

      def output
        @value.singularize.capitalize
      end

      def present?
        @value.present?
      end

      protected

      def process!(query)
        query.scan(/update\s(.*?[^,])[\s|;]/).flatten.first.to_s.delete('][\'\"')
      end
    end
  end
end
