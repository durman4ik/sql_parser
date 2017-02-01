class SqlController < ApplicationController
  before_action :set_sql_string, only: :convert

  def index
    @sql = Sql.new
  end

  def convert
    if @sql.migration?
      @sql.process_migration
    elsif @sql.query?
      @sql.process_sql
    else
      @sql.error = 'Undefined sql type'
    end
    render action: :index
  end

  private

  def set_sql_string
    @sql = Sql.new(convert_params[:query])
  end

  def convert_params
    params.require(:sql).permit(:query)
  end
end
