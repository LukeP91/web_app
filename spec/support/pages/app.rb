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
    Admin::Users::IndexPage.new
  end

  def admin_show_page
    Admin::Users::ShowPage.new
  end

  def admin_edit_page
    Admin::Users::EditPage.new
  end

  def admin_new_page
    Admin::Users::NewPage.new
  end

  def admin_categories_index_page
    Admin::Categories::IndexPage.new
  end
end
