require "spec_helper"

require "configuration_loader"

describe ConfigurationLoader do

  def load(path)
    ConfigurationLoader.load(path)
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
