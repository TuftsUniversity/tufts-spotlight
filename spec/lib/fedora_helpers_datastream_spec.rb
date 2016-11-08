require 'rails_helper'

describe FedoraHelpers::Datastream do
  let(:pid) { "tufts:MS054.003.DO.02108" }
  let(:ds_name) { "DCA-META" }
  let(:obj) {
    stream = ActiveFedora::Base.find(pid).datastreams[ds_name]
    FedoraHelpers::Datastream.new(stream)
  }

  describe "initialization" do
    context "with a valid stream" do
      it "saves a Nokogiri document to attr_readable @xml" do
        expect(obj.xml.class).to eq(Nokogiri::XML::Document)
      end

      it "sets attr_readable @pid to be the pid" do
        expect(obj.pid).to eq(pid)
      end

      it "sets attr_accessible @default_root to be the root element" do
        expect(obj.default_root).to eq("/#{obj.get_root}")
      end
    end

    context "with an invalid stream" do
      it "saves an empty string to xml" do
        obj = FedoraHelpers::Datastream.new({})
        expect(obj.xml).to eq("")
      end
    end
  end # End describe initialization

  describe "attr_accessors" do
    it "allows @default_root to be overwritten" do
      new_root = "/blah"
      obj.default_root = new_root
      expect(obj.default_root).to eq(new_root)
    end
  end

  describe "get_root" do
    it "returns the root element's name" do
      expect(obj.get_root).to eq("dca_dc:dc")
    end
  end

  describe "get_text" do
    context "with valid path" do
      it "returns the text from the first matching element" do
        expect(obj.get_text("dcadesc:subject")).to eq("Houses")
      end
    end

    context "with invalid path" do
      it "returns an empty string" do
        expect(obj.get_text("dc:liajd")).to eq("")
      end
    end

    # No testing for syntax errors here. That's done in get_all_text.
  end # End describe get_text

  describe "get_all_text" do
    it "returns an array of all texts from matching elements" do
      correct_answer = ["Houses", "Edwin B. Rollins, papers"]
      expect(obj.get_all_text("dcadesc:subject")).to eq(correct_answer)
    end

    context "with syntax error" do
      it "swallows the exception and still returns an empty array" do
        expect(obj.get_all_text("bad_ns:blah")).to eq([])
      end
    end
  end # End describe get_all_text

end

