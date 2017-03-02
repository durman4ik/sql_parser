class JsController < ApplicationController

  def coffee

  end

  def yopta
    @yopta = Yopta.new
    @yopta.placeholder = "йопта()жЫ\n    шухер('Hello World') нах\nесть"
  end
end
