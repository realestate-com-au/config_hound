require "spec_helper"

require "configuration_loader/resource"
require "uri"

describe ConfigurationLoader::Resource do

  let(:resource) { described_class.new(path) }

  context "with a URI" do

    let(:uri) { URI("http://example.com/some_uri") }
    let(:path) { uri }

    it "retains the URI" do
      expect(resource.to_s).to eq(uri.to_s)
    end

  end

  context "with a fully-qualified path" do

    let(:path) { "/path/to/file" }

    it "assumes it's a file" do
      expect(resource.to_s).to eq("file:/path/to/file")
    end

    describe "#resolve" do

      context "with a relative path" do
        it "resolves relatively" do
          other_resource = resource.resolve("other_file")
          expect(other_resource).to be_a(ConfigurationLoader::Resource)
          expect(other_resource.to_s).to eq("file:/path/to/other_file")
        end
      end

      context "with an absolute file path" do
        it "resolves relatively" do
          other_resource = resource.resolve("/different/path")
          expect(other_resource.to_s).to eq("file:/different/path")
        end
      end

      context "with a fully-qualified URI" do
        it "uses the URI provided" do
          other_resource = resource.resolve("http://foo/bar")
          expect(other_resource.to_s).to eq("http://foo/bar")
        end
      end

    end

  end

  context "with a relative path" do

    let(:path) { "config.yml" }

    it "assumes it's a file relative to $CWD" do
      expect(resource.to_s).to eq("file:#{Dir.pwd}/config.yml")
    end

  end

end
