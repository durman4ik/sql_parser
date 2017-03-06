class Sql
  include SqlSelect
  include SqlFrom
  include SqlUpdate
  include SqlJoins
  include SqlWheres
  include SqlSets
  include SqlOrderBy
  include SqlGroupBy
  include SqlLimit
  include SqlOffset

  include Getters

  attr_accessor :sql_method, :query, :query, :output, :error, :group_by, :order_by, :from,
                :wheres, :limit, :joins, :select, :update, :sets, :offset

  TYPES = {
      s: 'select',
      u: 'update',
      d: 'delete',
      i: 'insert'
      # ct: 'create table',
      # at: 'alter table',
      # dt: 'drop table',
      # ci: 'create index',
      # di: 'drop index'
  }.freeze

  def initialize(query = '')
    @query = query.gsub("\r\n", ' ').strip.downcase
    @error = nil
    @limit = nil
    @offset = nil
    @output   = ''
    @wheres   = []
    @joins    = []
    @group_by = []
    @order_by = []
    @sql_method = @query.determine_sql_type
  end

  def process_sql
    check_semicolon!
    unless self.error.present?
      parse!
      self.validate_select!
    end
  end

  def process_migration
    # TODO: not implemented yet.
  end

  def migration?
    %i(ct at dt ci di).include? sql_method
  end

  def query?
    %i(s u d i).include? sql_method
  end

  protected

  def build_output
    case self.sql_method
    when :s then build_select_output
    when :d then build_delete_output
    when :u then build_update_output
    when :i then build_insert_output
    end
  end

  def validate_select!
    if self.from.present?
      self.error = nil
    else
      self.error = '# Undefined model name. Please add FROM statement!'
      self.output = self.error
    end
  end

  private

  def build_select_output
    @output = ''
    @output << self.from.output
    @output << (self.select.output  || say_all?)
    @output << self.joins.output    if joins.present?
    @output << self.wheres.output   if wheres.present?
    @output << self.order_by.output if order_by.present?
    @output << self.group_by.output if group_by.present?
    @output << self.limit.output    if limit.present?
    @output << self.offset.output    if offset.present?
  end

  def build_update_output
    @output = ''
    @output << self.update.output
    @output << self.wheres.output   if wheres.present?
    @output << self.sets.output     if sets.present?
  end

  def build_delete_output
    @output = ''
    @output << self.from.output
    @output << self.joins.output    if joins.present?
    @output << self.wheres.output   if wheres.present?
    @output << self.order_by.output if order_by.present?
    @output << self.group_by.output if group_by.present?
    @output << '.destroy_all'
  end

  def build_insert_output

  end

  def say_all?
    c = select.all?        &&
        !wheres.present?   &&
        !joins.present?    &&
        !group_by.present? &&
        !order_by.present? &&
        !limit.present?

    c ? '.all' : ''
  end

  def check_semicolon!
    if self.query.strip.last.eql?(';')
      self.error = nil
    else
      self.error = '# You missed \';\' at the end!'
      self.output = self.error
    end
  end

  def parse!
    self.from         = Sql::From.new(self)
    self.update       = Sql::Update.new(self)
    self.select       = Sql::Select.new(self)
    self.limit        = Sql::Limit.new(self)
    self.group_by     = Sql::GroupBy.new(self)
    self.joins        = Sql::Joins.new(self)
    self.wheres       = Sql::Wheres.new(self)
    self.sets         = Sql::Sets.new(self)
    self.order_by     = Sql::OrderBy.new(self)
    self.offset       = Sql::Offset.new(self)
    self.build_output
  end
end
