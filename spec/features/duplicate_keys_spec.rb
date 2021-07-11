require "spec_helper"

require "config_hound"

describe ConfigHound, "duplicate_keys" do

  let(:config) { ConfigHound.load(resource, options) }

  given_resource "config.yaml", %{
    foo:
      bar: baz
      bar: qux
  }

  given_resource "config.json", %[
    { "foo": { "bar": "baz", "bar": "qux" } }
  ]

  %w(yaml json).each do |type|

    context "in #{type}" do

      let(:resource) { "config.#{type}" }

      context "with duplicate keys allowed" do
        let(:options) { { allow_duplicate_keys: true } }

        it "takes the later key" do
          expect(config).to eq("foo" => { "bar" => "qux" })
        end
      end

      context "with duplicate keys disabled" do
        let(:options) { { allow_duplicate_keys: false } }

        it "raises a DuplicateKeyError" do
          expect { config }.to raise_error(ConfigHound::Parser::DuplicateKeyError)
        end

        it "tells you which key is duplicated" do
          expect { config }.to raise_error(ConfigHound::Parser::DuplicateKeyError, /foo\.bar/)
        end
      end
    end

  end
end
