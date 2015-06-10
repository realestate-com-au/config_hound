
describe ConfigHound do

  let(:options) { {} }

  def load(path)
    ConfigHound.load(path, options)
  end

  let(:config) { load("config.yml") }

  context "when file includes another" do

    given_resource "config.yml", %{
      foo: 42
      _include: included.yml
    }

    given_resource "included.yml", %{
      foo: 1
      bar: 2
    }

    it "merges in the included file" do
      expect(config).to eq(
        "foo" => 42,
        "bar" => 2
      )
    end

  end

  context "when the included file has a different format" do

    given_resource "config.yml", %{
      foo: 42
      _include: included.toml
    }

    given_resource "included.toml", %{
      foo = 1
      bar = 2
    }

    it "doesn't matter" do
      expect(config).to eq(
        "foo" => 42,
        "bar" => 2
      )
    end

  end

  context "with multiple levels of inclusion" do

    given_resource "config.yml", %{
      from_config: C
      _include: a.yml
    }

    given_resource "a.yml", %{
      from_a: A
      _include: b.yml
    }

    given_resource "b.yml", %{
      from_b: B
    }

    it "merges in both files" do
      expect(config).to eq(
        "from_config" => "C",
        "from_a" => "A",
        "from_b" => "B"
      )
    end

  end

  context "with an alernate :include_key" do

    before do
      options[:include_key] = "slurp"
    end

    given_resource "config.yml", %{
      _include: a.yml
      slurp: b.yml
    }

    given_resource "a.yml", %{
      from_a: A
    }

    given_resource "b.yml", %{
      from_b: B
    }

    it "uses the specified include-key" do
      expect(config).to eq(
        "_include" => "a.yml",
        "from_b" => "B"
      )
    end

  end

  context "with relative inclusion" do

    given_resource "config.yml", %{
      from_config: C
      _include: subdir/a.yml
    }

    given_resource "subdir/a.yml", %{
      from_a: A
      _include: b.yml
    }

    given_resource "subdir/b.yml", %{
      from_b: B
    }

    it "resolves the relative references" do
      expect(config).to eq(
        "from_config" => "C",
        "from_a" => "A",
        "from_b" => "B"
      )
    end

  end

  context "with deep structures" do

    given_resource "config.yml", %{
      _include: defaults.yml
      nested:
        stuff:
          name: Stuff
          strategy: none
    }

    given_resource "defaults.yml", %{
      nested:
        stuff:
          size: large
          strategy:
            first: think
            then: do
    }

    it "merges deeply" do
      expect(config).to eq(
        "nested" => {
          "stuff" => {
            "name" => "Stuff",
            "size" => "large",
            "strategy" => "none"
          }
        }
      )
    end

  end

  context "with multiple includes" do

    given_resource "config.yml", %{
      _include:
      - fileA.yml
      - fileB.yml
    }

    given_resource "fileA.yml", %{
      direction: north
      fromA: true
    }

    given_resource "fileB.yml", %{
      direction: south
      fromB: true
    }

    it "loads both files" do
      expect(config).to have_key("fromA")
      expect(config).to have_key("fromB")
    end

  end
end


