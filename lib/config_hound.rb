require "config_hound/interpolation"
require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.load(paths, options = {})
    options = Hash[options]
    expand_refs = options.delete(:expand_refs)
    result = Loader.new(options).load(paths)
    result = Interpolation.expand(result) if expand_refs
    result
  end

end
