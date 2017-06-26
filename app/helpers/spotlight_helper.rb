##
# Global Spotlight helpers
module SpotlightHelper
  include ::BlacklightHelper
  include Spotlight::MainAppHelpers

  def abbrev_field(text)
    if(text.length <= 140)
      return text
    end

    # Using 110 and 100 as ranges because little point in cutting a single word off.
    last_space_within_range = text.slice(0..125).rindex(/\s/)
    text.slice(0..last_space_within_range) + "  . . ."
  end
end
