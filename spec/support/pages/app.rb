class App
  def login_page
    LoginPage.new
  end

  def home_page
    Profile::Home.new
  end

  def edit_profile_page
    Profile::EditPage.new
  end

  def admin_index_page
    Admin::IndexPage.new
  end

  def admin_show_page
    Admin::ShowPage.new
  end

  def admin_edit_page
    Admin::EditPage.new
  end

  def admin_new_page
    Admin::NewPage.new
  end
end
