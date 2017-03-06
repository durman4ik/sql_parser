class Js2yoptaController < ApplicationController

  def index
    @page_title = 'Js2Yopta Converter'
    @yopta = Yopta.new
    @yopta.placeholder = "йопта()жЫ\n    шухер('Hello World') нах\nесть"
  end
end
