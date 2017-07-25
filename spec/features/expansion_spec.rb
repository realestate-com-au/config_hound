require "spec_helper"

require "config_hound"

describe ConfigHound, "expansion" do

  given_resource "config.yml", %{
    var:
      port: 5678
    address: host:<(var.port)>
  }

  let(:config) { ConfigHound.load("config.yml", :expand_refs => true) }

  it "expands references" do
    expect(config["address"]).to eq("host:5678")
  end

  context "with overrides" do

    given_resource "overrides.yml", %{
      _include:
        - config.yml
      var:
        port: 9999
    }

    let(:config) { ConfigHound.load("overrides.yml", :expand_refs => true) }

    it "merges before expanding" do
      expect(config["address"]).to eq("host:9999")
    end

  end

end
