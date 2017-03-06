require 'html2haml/html'

class Html
  attr_accessor :html, :haml, :output, :old_ruby, :slim

  def initialize(data = {})
    @old_ruby = data[:old_ruby]
    @html = data[:html]
    @haml = data[:haml]
    @slim = data[:slim]
  end

  def convert_to_haml
    @output = parse_html

    to_new_ruby_syntax unless @old_ruby
  end

  def convert_to_slim
    @output = parse_html(:slim)

    to_new_ruby_syntax unless @old_ruby
  end

  private

  def parse_html(mode = :haml)
    if mode == :haml
      haml = Haml::HTML.new(@html)
      haml.render
    else
      slim = HTML2Slim.convert!(@html, :erb)
      slim.to_s
    end
  end

  def to_new_ruby_syntax
    ar = @output.split(/(:\w*\s=>\s)/)
    ar.map { |e| e.tr!(':', '') && e.gsub!(' =>', ':') if e.include?(' => ') }
    @output = ar.join
  end
end
