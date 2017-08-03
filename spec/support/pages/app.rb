class App
  def home_page
    Home.new
  end

  def login_page
    LoginPage.new
  end

  def edit_profile_page
    EditProfilePage.new
  end

  def admin_index_page
    Admin::IndexPage.new
  end
end
