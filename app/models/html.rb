require 'html2haml/html'

class Html
  attr_accessor :html, :haml, :output, :old_ruby

  def initialize(data = {})
    @old_ruby = data[:old_ruby]
    @html = data[:html]
    @haml = data[:haml]
  end

  def convert_to_haml
    @output = parse_haml
    @output.gsub!(' => ', ': ') unless @old_ruby
  end

  private

  def parse_haml
    engine = Haml::HTML.new(@html)
    engine.render
  end
end
