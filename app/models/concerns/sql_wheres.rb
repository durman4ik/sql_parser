module SqlWheres
  extend ActiveSupport::Concern

  included do

    class self::Wheres
      attr_accessor :all
      OP_REGEX = '<|>|<=|>=|=|like|in|between'.freeze

      class Condition
        attr_accessor :key, :value, :operator

        OPERATORS = %w(< > <= >= = like in between).freeze

        def initialize(k, v, o = nil)
          @key = k
          @value = v
          @operator = o
        end
      end

      def initialize(sql)
        @all = self.process!(sql.query)
      end

      def output
        binding.pry
      end

      def present?
        @all.present?
      end

      protected

      def process!(query)
        ts = self.find_conditions(query)
        self.process_where_conditions_string(ts)
      end

      def find_conditions(query)
        query.scan(/where((?:.*?(?:#{OP_REGEX})?'.*'|.*(?:#{OP_REGEX}).)(?:[^\s]*))/i).flatten.first.to_s
      end

      def process_where_conditions_string(temp_string)
        @child_conditions = temp_string.scan(/\s\((.*?)[)]+/).flatten.map { |q| q.split(/\s(or|and)\s/) }
        first_level_string = temp_string.gsub(/\s\((.*?)[)]+/, ' [CHILD]')
        first_level_array = first_level_string.split(/\s(or|and)\s/)
        parse_first_level_array(first_level_array)
      end

      def parse_child_conditions(c)
        hash = {}
        c.each_with_index do |o, i|
          hash[i] = { }
          parse_condition(hash[i], o)
        end
        hash
      end

      def parse_first_level_array(f)
        h = { }
        parse_condition(h, f)
      end

      def parse_condition(hash, o)
        o.each_with_index do |c, n|
          key = get_key(o, n)

          if n < o.size && n.next.odd?
            hash[key] = [] if hash[key].blank?
            hash[key] << create_condition(c)
          else
            next
          end
        end
        hash
      end

      def create_condition(c)
        if c.eql?('[CHILD]')
          tmp = [c, parse_child_conditions(@child_conditions)]
        else
          tmp = c.gsub(/'|"/, '').partition(/"#{OP_REGEX}"/)
        end
        Condition.new(tmp[0], tmp[2], tmp[1])
      end

      def get_key(o, n)
        if n.next == o.size
          o[n.pred].to_sym
        elsif n.next < o.size
          o[n.next].to_sym
        end
      end
    end
  end
end
