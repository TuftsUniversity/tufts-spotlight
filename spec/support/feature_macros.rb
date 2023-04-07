# frozen_string_literal: true

# @file
# Contains methods for feature tests.

module FeatureMacros
  ##
  # Signs in.
  #
  # @params
  #   user {User} The user that's logging in.
  def sign_in(user)
    visit('users/sign_in')
    fill_in('user_username', with: user.username)
    fill_in('user_password', with: user.password)
    click_button('Log in')
  end

  ##
  # Adds a block of a specific data type to a page.
  #
  # @params
  #   data_type {string} The value of the 'data-type' attribute on the sir trevor icon.
  def add_block(data_type)
    within('#st-editor-1') do
      click_button(class: 'st-block-replacer', match: :first)
      find(:xpath, "//button[@data-type='#{data_type}']").click
    end
  end

  ##
  # Checks or unchecks the 'Show sidebar' box.
  #
  # @params
  #   action {string} 'add' or 'remove'.
  def toggle_sidebar(action = 'add')
    click_on('Options')
    if action == 'add'
      check('Show sidebar')
    elsif action == 'remove'
      uncheck('Show sidebar')
    end
    click_on('Content')
    sleep(0.5)
  end

  ##
  # Add an autocomplete item to a block.
  #
  # @params
  #   starts_with {string} What does the autocomplete value start with?
  def add_autocomplete_item(starts_with = 'f')
    within('#st-editor-1') do
      fill_in(class: 'st-input-string', with: starts_with)
      find('.autocomplete-item').click
    end
  end

  ##
  # Removes an autocomplete item from a block
  def remove_autocomplete_item
    within('#st-editor-1') do
      first(:link, 'Remove').click
    end
  end
end
