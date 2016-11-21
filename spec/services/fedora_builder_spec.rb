require 'yaml'

require 'rails_helper'
require 'lib/fedora_helpers_spec'

describe FedoraBuilder do
  it_behaves_like FedoraHelpers

  let(:obj) do
    # This file is created/deleted in rails_helper
    YAML::load(File.open("#{Rails.root}/tmp/fedora_builder_spec.yml"))
  end

  describe "initialize" do
    it "loads the yaml into @settings" do
      expect(obj.instance_variable_get(:@settings)).not_to be_empty
    end

    it "loads the default_ns from @settings" do
      expect(obj.instance_variable_get(:@settings)[:default_element][:ns]).to eq("dc")
    end
  end

  describe "to_solr" do
    let(:doc) { obj.to_solr }

    describe "administrative metadata" do
      it "strips namespace and dots from id" do
        expect(doc[:id]).to eq("MS054003DO02108")
      end

      it "saves the pid to the doc" do
        expect(doc[:f3_pid_ssi]).to eq("tufts:MS054.003.DO.02108")
      end

      it "sets the correct resource type" do
        expect(doc[:spotlight_resource_type_ssim]).to eq("spotlight/resources/fedora")
      end

      it "sets the correct title" do
        expect(doc[:full_title_tesim]).to eq("114 Professors Row")
      end
    end

    describe "image metadata" do
      it "sets the correct image urls" do
        expect(doc).to include({
          Spotlight::Engine.config.full_image_field =>
            "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/advanced_jpg/MS054.003.DO.02108.advanced.jpg",
          Spotlight::Engine.config.thumbnail_field =>
             "http://bucket01.lib.tufts.edu/data01/tufts/central/dca/MS054/thumb_png/MS054.003.DO.02108.thumb.png"
        })
      end

      it "adds image dimensions to the doc" do
        expect(doc).to include(
          :spotlight_full_image_width_ssm,
          :spotlight_full_image_height_ssm
        )
      end
    end

    describe "descriptive metadata" do
      it "adds the DCA-META metadata" do
        expect(doc).to include(
          "description_tesim" => ["3x5, box:  \"Residences\""],
          "subject_tesim" => ["Houses", "Edwin B. Rollins, papers"]
        )
      end

      context "no values found" do
        it "strips namespace and re-queries if !strict" do
          expect(doc).to include( "creator_tesim" => ["Rollins, Edwin B."] )
        end
      end

      it "adds fields with non-default namespaces" do
        expect(doc).to include("subject_tesim")
      end

      it "adds multiple values for one field" do
        expect(doc).to include(
          "subject_tesim" => ["Houses", "Edwin B. Rollins, papers"]
        )
      end

      it "adds fields from multiple datastreams" do
        expect(doc).to include("member_of_tesim")
      end

      it "adds fields with custom solr names" do
        expect(doc).to include("member_of_tesim")
        expect(doc).to include("published_by_tesim")
      end

      it "adds fields with full xpath in config file" do
        expect(doc).to include(
          "member_of_tesim" => ["info:fedora/tufts:UA069.006.DO.MS054"]
        )
      end

      it "adds fields from attributes" do
        expect(doc).to include(
          "member_of_tesim" => ["info:fedora/tufts:UA069.006.DO.MS054"]
        )
      end
    end # End descriptive metadata
  end # End describe to_solr

end # End describe FedoraBuilder



