require "spec_helper"

require "config_hound"

describe ConfigHound, "sources" do

  let(:defaults) do
    {
      "meta" => {
        "winner" => "defaults"
      },
      "data" => {
        "from-defaults" => "D"
      }
    }
  end

  given_resource "fileA.yml", %{
    meta:
      winner: fileA
    data:
      from-fileA: A
  }

  given_resource "fileB.yml", %{
    meta:
      winner: fileB
    data:
      from-fileB: B
  }

  let(:overrides) do
    {
      "meta" => {
        "winner" => "overrides"
      },
      "data" => {
        "from-overrides" => "O"
      }
    }
  end

  let(:config) do
    ConfigHound.load([overrides, "fileA.yml", "fileB.yml", defaults])
  end

  it "merges file contents with hashes" do
    data = config.fetch("data")
    expect(data["from-overrides"]).to eql("O")
    expect(data["from-fileA"]).to eql("A")
    expect(data["from-fileB"]).to eql("B")
    expect(data["from-defaults"]).to eql("D")
  end

  it "favours the earliest source" do
    expect(config["meta"]["winner"]).to eq("overrides")
  end

end
