module GivenResource

  def inputs
    @inputs ||= {}
  end

  def given_resource(path, content)
    unless path =~ %r(^\w+:/)
      path = File.expand_path(path)
    end
    content = undent(content)
    before do
      allow_any_instance_of(ConfigHound::Resource).to receive(:open).with(path) do |_, _, &block|
        block.call(StringIO.new(content.dup))
      end
    end
  end

  private

  def undent(raw)
    # raw = raw.gsub(/^ *$/,'')
    if raw =~ /\A( +)/
      indent = $1
      raw.gsub(/^#{indent}/, '').gsub(/ +$/, '')
    else
      raw
    end
  end

end

RSpec.configure do |config|
  config.warnings = true

  config.extend(GivenResource)

  config.before do
    allow_any_instance_of(ConfigHound::Resource).to receive(:open) do |_, path, &block|
      raise Errno::ENOENT, "can't load: #{path}"
    end
  end

end
