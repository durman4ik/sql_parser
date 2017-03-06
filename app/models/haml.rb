class HAML
  attr_accessor :html, :haml, :output, :old_ruby, :slim

  def initialize(data = {})
    @old_ruby = data[:old_ruby]
    @html = data[:html]
    @haml = data[:haml]
    @slim = data[:slim]
  end

  def convert_to_slim
    @output = parse_haml(:haml)
  end

  private

  def parse_haml(mode = :html)
    result =
        if mode == :html
          # TODO: not implemented yet.
        else
          Haml2Slim.convert!(@haml)
        end

    result.to_s
  end
end
