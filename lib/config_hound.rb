require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.load(path)
    Loader.load(path)
  end

end


