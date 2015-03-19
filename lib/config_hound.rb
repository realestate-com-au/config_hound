require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.load(*args)
    Loader.load(*args)
  end

end


