require 'rails_helper'

describe FedoraBuilder do
  it_behaves_like FedoraHelpers

  let(:obj) do
    # This file is created/deleted in rails_helper
    YAML::load(File.open("#{Rails.root}/tmp/fedora_builder_spec.yml"))
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
            "https://dl.tufts.edu/file_assets/advanced/tufts:MS054.003.DO.02108",
          Spotlight::Engine.config.thumbnail_field =>
             "https://dl.tufts.edu/file_assets/thumb/tufts:MS054.003.DO.02108"
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
          "subject_tesim" => ["Houses", "Edwin B. Rollins, papers"],
          "creator_tesim" => ["Rollins, Edwin B."]
        )
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

      it "adds facet fields" do
        expect(doc).to include(
          "subject_sim" => ["Houses", "Edwin B. Rollins, papers"],
          "creator_sim" => ["Rollins, Edwin B."]
        )
      end

    end # End descriptive metadata
  end # End describe to_solr

end # End describe FedoraBuilder



