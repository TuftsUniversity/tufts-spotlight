module LoginMacros
  def sign_in(user)
    visit(root_path)
    click_link('Sign in', match: :first)
    fill_in('user_username', with: user.username)
    fill_in('user_password', with: user.password)
    click_button('Log in')
  end
end
