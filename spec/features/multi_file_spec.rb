require "spec_helper"

require "config_hound"

describe ConfigHound do

  def load(path)
    ConfigHound.load(path)
  end

  let(:config) { load(["fileA.yml", "fileB.yml"]) }

  given_resource "fileA.yml", %{
    source: A
    fromA: true
  }

  given_resource "fileB.yml", %{
    source: B
    fromB: true
  }

  it "loads both files" do
    expect(config).to have_key("fromA")
    expect(config).to have_key("fromB")
  end

  it "favours earliest included file" do
    expect(config["source"]).to eq("A")
  end

end
