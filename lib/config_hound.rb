require "config_hound/parser"
require "config_hound/resource"
require "config_hound/version"

class ConfigHound

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


