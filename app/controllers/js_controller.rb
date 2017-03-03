class JsController < ApplicationController

  def coffee
    @page_title = 'Js2Coffee Converter'
  end

  def yopta
    @page_title = 'Js2Yopta Converter'
    @yopta = Yopta.new
    @yopta.placeholder = "йопта()жЫ\n    шухер('Hello World') нах\nесть"
  end
end
