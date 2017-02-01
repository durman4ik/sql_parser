module SqlJoins
  extend ActiveSupport::Concern

  included do

    class self::Joins
      attr_accessor :all

      class InnerJoin
        attr_accessor :value
      end

      class LeftJoin
        attr_accessor :value
      end

      class RightJoin
        attr_accessor :value
      end

      class FullJoin
        attr_accessor :value
      end

      def initialize(sql)
        @all = []

        j = self.find_joins(sql)
        j.each { |join| @all << self.create_join_by_type(join) }
      end

      def output
        result = ''
        @all.each do |join|
          result << ".joins(:#{join.value})"           if join.class == InnerJoin
          result << ".includes(:#{join.value})"        if join.class == LeftJoin
          result << ".not_implemented(:#{join.value})" if join.class == RightJoin
          result << ".not_implemented(:#{join.value})" if join.class == FullJoin
        end
        result
      end

      def present?
        @all.present?
      end

      protected

      def find_joins(sql)
        temp = sql.query.gsub(' outer j', ' j')
        temp.scan(/((?:(?:inner|left|right|full)\s+)?join\s+[^=]*=\s*\S+\b)/).flatten
      end

      def create_join_by_type(join)
        fw = join.first_word
        j =
            case join.first_word
            when 'left', 'right', 'inner', 'full' then eval("Sql::Joins::#{fw.capitalize}Join").new
            when 'join' then Sql::Joins::InnerJoin.new
            else return nil
            end

        j.value = join.scan(/join\s(.*?[^,])[\s|;]/).flatten.first.to_s
        j
      end
    end
  end
end
