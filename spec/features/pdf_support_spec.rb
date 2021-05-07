require 'rails_helper'
require 'webdrivers/chromedriver'
include FeatureMacros
i_need_ldap

feature "PDF Support" do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:image) do
    FactoryBot.create(
      :featured_image,
      image: File.open(File.join(FIXTURES_PATH, 'stego.jpg'))
    )
  end
  let(:image_upload) do
    FactoryBot.create(
      :uploaded_resource,
      exhibit: exhibit,
      upload: image
    )
  end
  let(:pdf) do
    FactoryBot.create(
      :featured_image,
      image: File.open(File.join(FIXTURES_PATH, 'test.pdf'))
    )
  end
  let(:pdf_upload) do
    FactoryBot.create(
      :uploaded_resource,
      exhibit: exhibit,
      upload: pdf
    )
  end

  scenario 'PDFs should have a "View PDF" link on display' do
    pdf_upload.reindex
    sleep(1)
    visit(spotlight.exhibit_solr_document_path(exhibit, pdf_upload.compound_id))
    expect(page).to have_content("View PDF")

    click_on('View PDF')
    expect(page.response_headers['Content-Type']).to eq('application/pdf')
  end

  scenario 'Images should not have "View PDF" link on display' do
    image_upload.reindex
    sleep(1)
    visit(spotlight.exhibit_solr_document_path(exhibit, image_upload.compound_id))
    expect(page).not_to have_content("View PDF")
  end
end
