require "configuration_loader/parser"
require "configuration_loader/resource"
require "configuration_loader/version"

class ConfigurationLoader

  def self.load(path)
    new.load(path)
  end

  def load(path)
    resource = Resource.new(path.to_s)
    data = Parser.parse(resource.read, resource.format)
    includes = Array(data.delete("_include"))
    includes.each do |i|
      included_data = load(resource.resolve(i))
      data = deep_merge(included_data, data)
    end
    data
  end

  private

  def deep_merge(a, b)
    if a.is_a?(Hash) && b.is_a?(Hash)
      a.merge(b) { |key, av, bv| deep_merge(av, bv) }
    else
      b
    end
  end

end


