require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.load(paths, options = {})
    Loader.new(options).load(paths)
  end

end


