##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  ##
  # Cuts text fields down to a specific length and adds ellipses.
  #
  # @param {String} text
  #   The text to cut.
  def abbrev_field(text)
    if(text.length <= 140)
      return text
    end

    # Using 110 and 100 as ranges because little point in cutting a single word off.
    last_space_within_range = text.slice(0..125).rindex(/\s/)
    text.slice(0..last_space_within_range) + "  . . ."
  end

  ##
  # Makes a field into a link. Used in field configuration in CatalogController.
  #
  # @param {Hash} field
  #   The field options.
  def make_this_a_link(field = {}, link_text = '')
    url = field[:value].first
    text = link_text.empty? ? url : link_text

    link_to(text, url, target: '_blank')
  end

  ##
  # Makes tufts_source_location_tesim fields into clickable links on display.
  #
  # @param {Hash} field
  #   The field to display.
  def make_source_location_link(field)
    make_this_a_link(field, t(:"tufts.uploads.fields.external_url.value"))
  end
end
