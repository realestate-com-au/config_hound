require "spec_helper"

require "config_hound/interpolation"

describe ConfigHound::Interpolation do

  describe ".expand" do

    let(:output) { described_class.expand(input) }

    context "with a simple config Hash" do

      let(:input) do
        {
          "author" => {
            "name" => "Mike"
          }
        }
      end

      it "returns the input" do
        expect(output).to eql(input)
      end

    end

    context "with reference" do

      let(:input) do
        {
          "x" => 42,
          "y" => "<(x)>"
        }
      end

      it "expands the reference" do
        expect(output["y"]).to eql(42)
      end

    end

    context "with complex reference" do

      let(:input) do
        {
          "vars" => {
            "author" => {
              "name" => "Mike"
            }
          },
          "foo" => "<(vars.author.name)>"
        }
      end

      it "expands the reference" do
        expect(output["foo"]).to eql("Mike")
      end

    end

    context "with reference in nested object" do

      let(:input) do
        {
          "vars" => {
            "author" => {
              "name" => "Mike"
            }
          },
          "foo" => {
            "bar" => "<(vars.author.name)>"
          }
        }
      end

      it "expands the reference" do
        expect(output["foo"]["bar"]).to eql("Mike")
      end

    end

    context "with reference embedded in a String" do

      let(:input) do
        {
          "size" => 42,
          "desc" => "Size <(size)>"
        }
      end

      it "expands the reference" do
        expect(output["desc"]).to eql("Size 42")
      end

    end

    context "when multiple references" do

      let(:input) do
        {
          "everything" => "<(parts.first)> and <(parts.last)>",
          "parts" => {
            "first" => "<(article)> one",
            "last" => "<(article)> two"
          },
          "article" => "Part"
        }
      end

      it "expands the reference" do
        expect(output["everything"]).to eql("Part one and Part two")
      end

    end

    context "with circular reference" do

      let(:input) do
        {
          "ping" => "refers to <(pong)>",
          "pong" => "refers to <(ping)>"
        }
      end

      it "raises a ReferenceError" do
        expect {
          output
        }.to raise_error(ConfigHound::Interpolation::ReferenceError)
      end

    end

    context "with unresolved reference" do

      let(:input) do
        {
          "foo" => "refers to <(bar)>"
        }
      end

      it "raises a ReferenceError" do
        expect {
          output
        }.to raise_error(ConfigHound::Interpolation::ReferenceError)
      end

    end

  end

end
