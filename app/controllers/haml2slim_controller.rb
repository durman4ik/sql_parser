class Haml2slimController < ApplicationController

  def index
    @haml = HAML.new
  end

  def create
    @haml = HAML.new(haml_params)
    @haml.convert_to_slim

    if haml_params[:save_as].present?
      save_file
    else
      render 'index'
    end
  end

  private

  def save_file
    if haml_params[:save_as][:html2haml]
      send_file_to_user(@haml.html, 'text/haml', 'file_name.haml')
    else
      send_file_to_user(@haml.haml, 'text/slim', 'file_name.slim')
    end
  end

  def send_file_to_user(file, type, filename)
    send_data file,
              type: type,
              disposition: 'attachment',
              filename: filename
  end

  def haml_params
    params.require(:data).permit(:haml, :slim, :old_ruby, save_as: [:haml, :slim])
  end
end
