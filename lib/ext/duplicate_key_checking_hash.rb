class DuplicateKeyCheckingHash < Hash
  attr_reader :duplicate_keys

  def initialize(default=nil)
    @duplicate_keys = []
    super(default)
  end

  def []=(key, value)
    if has_key?(key)
      @duplicate_keys << key
    end

    super(key, value)
  end
end
