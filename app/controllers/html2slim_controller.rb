class Html2slimController < ApplicationController

  def index
    @html = Html.new
  end

  def create
    @html = Html.new(html_params)
    @html.convert_to_slim

    if html_params[:save_as].present?
      save_file
    else
      render 'index'
    end
  end

  private

  def save_file
    if html_params[:save_as][:html2haml]
      send_file_to_user(@html.html, 'text/html', 'file_name.html')
    else
      send_file_to_user(@html.slim, 'text/slim', 'file_name.slim')
    end
  end

  def send_file_to_user(file, type, filename)
    send_data file,
              type: type,
              disposition: 'attachment',
              filename: filename
  end

  def html_params
    params.require(:data).permit(:html, :slim, :old_ruby, save_as: [:html, :slim])
  end
end
