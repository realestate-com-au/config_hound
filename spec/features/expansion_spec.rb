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

  context "with key expansion" do

    given_resource "config-with-key-expansion.yml", %{
      var:
        account_id: "123"
      <(var.account_id)>: value
    }

    let(:config) { ConfigHound.load("config-with-key-expansion.yml", :expand_refs => true) }

    it "expands key references" do
      expect(config["123"]).to eq("value")
    end

  end

  context "with key and value expansion" do

    given_resource "config-with-key-and-value-expansion.yml", %{
      var:
        account_id: "123"
        port: 5678
      <(var.account_id)>: host:<(var.port)>
    }
    let(:config) { ConfigHound.load("config-with-key-and-value-expansion.yml", :expand_refs => true) }
    
    it "expands key references" do
      expect(config["123"]).to eq("host:5678")
    end

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
