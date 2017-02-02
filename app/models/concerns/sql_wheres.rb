module SqlWheres
  extend ActiveSupport::Concern

  included do

    class self::Wheres
      attr_accessor :all, :child_conditions
        OP_REGEX = 'between|<|>|<=|>=|=|like|in'.freeze

      class Condition
        attr_accessor :key, :value, :operator

        OPERATORS = %w(< > <= >= = like in between).freeze

        def initialize(k, v, o = nil)
          @key = k
          @value = v
          @operator = o
        end

        def child?
          @key.eql?('[CHILD]')
        end
      end

      def initialize(sql)
        @all = self.process!(sql.query)
      end

      def output
        result = ''
        @all.map do |c, v|
          if c == '1'.to_sym
            result << where_operator_output(v.first)
          else
            result << build_where_output(v, c)
          end
        end

        return ".where(#{result})"
      end

      def where_operator_output(v)
        case v.operator
        when '='    then "#{v.key}: '#{v.value}'"
        when '>'    then ":#{v.key} > '#{v.value}'"
        when '<'    then ":#{v.key} < '#{v.value}'"
        when '!='   then ":#{v.key} < '#{v.value}'"
        when 'IN'   then "\"#{v.key} IN (?)\", #{v.value}"
        when 'LIKE' then "\"#{v.key} LIKE '%?%'\", #{v.value}"
        end
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

      private

      def build_child_output(o)
        tmp = parse_condition({}, self.child_conditions[o])
        o += 1

        ["(#{tmp.map { |k, v| build_where_output(v, k) }.join})"]
      end

      def build_where_output(v, c)
        tmp = []
        v.map.with_object(0) do |x, o|
          if x.child?
            tmp << build_child_output(o)
          else
            tmp << where_operator_output(x)
          end
        end

        tmp.first << and_or(c) if tmp.size == 1
        tmp.join(and_or(c))
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
        tmp = c.gsub(/'|"|;/, '').partition(/"#{OP_REGEX}"/)

        Condition.new(tmp[0].strip, tmp[2].strip, tmp[1].strip)
      end

      def get_key(o, n)
        if o.size == 1
          '1'.to_sym
        elsif n.next == o.size
          o[n.pred].to_sym
        elsif n.next < o.size
          o[n.next].to_sym
        end
      end

      def and_or(v)
        v == :or ? ' || ' : ' && '
      end
    end
  end
end
