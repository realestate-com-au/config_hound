require "spec_helper"

require "config_hound"

describe ConfigHound do

  let(:defaults) do
    {
      "meta" => {
        "winner" => "defaults"
      },
      "data" => {
        "from-defaults" => 1
      }
    }
  end

  given_resource "config.yml", %{
    meta:
      winner: file
    data:
      from-file: 2
  }

  let(:overrides) do
    {
      "meta" => {
        "winner" => "overrides"
      },
      "data" => {
        "from-overrides" => 3
      }
    }
  end

  let(:config) do
    ConfigHound.load([overrides, "config.yml", defaults])
  end

  it "merges file contents with hashes" do
    data = config.fetch("data")
    expect(data).to have_key("from-overrides")
    expect(data).to have_key("from-file")
    expect(data).to have_key("from-defaults")
  end

  it "favours the earliest source" do
    expect(config["meta"]["winner"]).to eq("overrides")
  end

end
