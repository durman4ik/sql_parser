class HtmlController < ApplicationController

  def index
    @page_title = 'Html2Haml Converter'
    @html = Html.new
  end

  def create
    @html = Html.new(html_params)
    @html.convert_to_haml

    if html_params[:save_as].present?
      save_file
    else
      render 'index'
    end
  end

  private

  def save_file
    if html_params[:save_as][:html]
      send_file_to_user(@html.html, 'text/html', 'file_name.html')
    else
      send_file_to_user(@html.haml, 'text/haml', 'file_name.html.haml')
    end
  end

  def send_file_to_user(file, type, filename)
    send_data file,
              type: type,
              disposition: 'attachment',
              filename: filename
  end

  def html_params
    params.require(:data).permit(:html, :haml, :old_ruby, save_as: [:html, :haml])
  end
end
