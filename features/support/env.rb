require "configuration_loader"
require "stringio"

class CustomConfigurationLoader < ConfigurationLoader

  attr_accessor :inputs

  def open(path)
    if inputs.has_key?(path)
      StringIO.new(inputs[path])
    else
      raise Errno::ENOENT, "no such file: #{path}"
    end
  end

end

Before do
  @inputs = {}
  @loader = CustomConfigurationLoader.new
  @loader.inputs = @inputs
end
