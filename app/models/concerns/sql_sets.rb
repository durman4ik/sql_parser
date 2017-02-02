module SqlSets
  extend ActiveSupport::Concern

  included do

    class self::Sets
      attr_accessor :all

      class Condition
        attr_accessor :key, :value

        def initialize(k, v)
          @key = k
          @value = v
        end

        def child?
          @key.eql?('[CHILD]')
        end
      end

      def initialize(sql)
        @all = self.process!(sql.query)
      end

      def output
        tmp = @all.map { |set| "#{set.key}: '#{set.value}'" }.join(', ')
        ".update(#{tmp})"
      end

      def present?
        @all.present?
      end

      protected

      def process!(query)
        args = query.scan(/set((?:.*?=?'.*'|.*=.)(?:[^\s;]*))/i).flatten
        args.map { |a| create_condition(a) }
      end

      private

      def create_condition(a)
        tmp = a.gsub(/'|"|;/, '').strip.split('=')

        Condition.new(tmp[0].strip, tmp[1].strip)
      end
    end
  end
end
