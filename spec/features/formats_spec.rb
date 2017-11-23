require "spec_helper"

require "config_hound"

describe ConfigHound, "formats" do

  def load(path)
    ConfigHound.load(path)
  end

  given_resource "config.yml", %{
    foo: 1
    bar: 2
  }

  it "loads YAML" do
    expect(load("config.yml")).to eq(
      "foo" => 1,
      "bar" => 2
    )
  end

  given_resource "config-with-aliases.yml", %{
    foo: &foo
      bar: 1
    baz:
      <<: *foo
  }

  it "loads YAML with aliases" do
    expect(load("config-with-aliases.yml")).to eq(
      "foo" => { "bar" => 1 },
      "baz" => { "bar" => 1 }
    )
  end

  given_resource "config.json", %{
    {
      "foo": 1,
      "bar": 2
    }
  }

  it "loads JSON" do
    expect(load("config.json")).to eq(
      "foo" => 1,
      "bar" => 2
    )
  end

  given_resource "config.toml", %{
    foo = 1
    bar = 2
  }

  it "loads TOML" do
    expect(load("config.toml")).to eq(
      "foo" => 1,
      "bar" => 2
    )
  end

end
