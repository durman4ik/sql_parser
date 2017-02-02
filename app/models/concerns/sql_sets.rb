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
        args_str = query.scan(/set((?:.*?=?'.*'|.*=.)(?:[^\s;]*))/i).flatten.first.to_s.strip
        create_condition(args_str)
      end

      private

      def create_condition(a)
        tmp = a.gsub(/'|"|;/, '').split(',').map(&:strip)

        tmp.map do |t|
          z = t.split('=')

          Condition.new(z[0].strip, z[1].strip)
        end.flatten
      end
    end
  end
end
