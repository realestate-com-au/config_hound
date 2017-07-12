require "config_hound/interpolation"
require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.load(paths, options = {})
    Interpolation.expand(Loader.new(options).load(paths))
  end

end
