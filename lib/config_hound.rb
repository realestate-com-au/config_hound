require "config_hound/loader"
require "config_hound/version"

module ConfigHound

  def self.with(options)
    Loader.new(options)
  end

  def self.load(*paths)
    Loader.new.load(*paths)
  end

end


