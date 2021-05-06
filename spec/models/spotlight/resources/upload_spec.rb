require 'rails_helper'

describe Spotlight::Resources::Upload, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:resource) { described_class.new(exhibit: exhibit) }
  let(:image) do
    FactoryBot.create(
      :featured_image,
      image: File.open(File.join(FIXTURES_PATH, 'stego.jpg'))
    )
  end
  let(:pdf) do
    FactoryBot.create(
      :featured_image,
      image: File.open(File.join(FIXTURES_PATH, 'test.pdf'))
    )
  end

  it 'contains a tufts_source_location field' do
    expect(Spotlight::Resources::Upload.fields(exhibit)).to include(an_object_satisfying { |f|
      f.instance_variable_get(:@field_name) == :tufts_source_location_tesim
    })
  end

  context 'indexing item types' do
    it 'indexes images as images' do
      resource.upload = image
      resource.save

      doc_builder = resource.document_builder
      expect(doc_builder.to_solr).to include(type_tesim: ['Image'])
    end

    it 'indexes pdfs as pdfs' do
      resource.upload = pdf
      resource.save

      doc_builder = resource.document_builder
      expect(doc_builder.to_solr).to include(type_tesim: ['Pdf'])
    end
  end
end
