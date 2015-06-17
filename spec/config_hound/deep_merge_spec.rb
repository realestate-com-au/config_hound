require "spec_helper"

require "config_hound/deep_merge"

describe ConfigHound do

  describe ".deep_merge_into" do

    let(:result) { ConfigHound.deep_merge_into(v1, v2) }

    context "with non-Hash arguments" do

      let(:v1) { "a" }
      let(:v2) { "b" }

      it "takes the second value" do
        expect(result).to eq("b")
      end

    end

    context "with independent keys" do

      let(:v1) { {a: 1} }
      let(:v2) { {b: 2} }

      it "merges" do
        expect(result).to eq(a: 1, b: 2)
      end

    end

    context "when keys clash" do

      let(:v1) { {x: 1} }
      let(:v2) { {x: 2} }

      it "takes the second value" do
        expect(result).to eq(x: 2)
      end

    end

    context "with nested values" do

      let(:v1) do
        {
          :foo => {
            :bar => {
              :x => 1
            }
          }
        }
      end

      let(:v2) do
        {
          :foo => {
            :bar => {
              :y => 2
            }
          }
        }
      end

      it "merges deeply" do
        expect(result).to eq(
          :foo => {
            :bar => {
              :x => 1,
              :y => 2
            }
          }
        )
      end

    end

  end

end
