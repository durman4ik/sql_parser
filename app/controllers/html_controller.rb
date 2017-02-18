class HtmlController < ApplicationController

  def index
    @html = Html.new
  end

  def create
    @html = Html.new(html_params)
    @html.convert_to_haml
    render 'index'
  end


  private

  def html_params
    params.require(:data).permit(:html, :haml, :old_ruby)
  end
end
