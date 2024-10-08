module LoginModule
  def login(user)
    visit login_path
    fill_in "email", with: user.email
    fill_in "password", with: "1a2b3c45"
    click_button "ログイン"
    expect(page).to have_text "ログインしました"
  end
end
