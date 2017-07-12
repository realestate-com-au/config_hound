require "spec_helper"

require "config_hound"

describe ConfigHound, "expansion" do

  let(:config) { ConfigHound.load("config.yml") }

  given_resource "config.yml", %{
    var:
      port: 5678
    address: host:<(var.port)>
  }

  it "expands references" do
    expect(config["address"]).to eq("host:5678")
  end

end
