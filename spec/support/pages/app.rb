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

  def admin_users_index_page
    Admin::Users::IndexPage.new
  end

  def admin_users_show_page
    Admin::Users::ShowPage.new
  end

  def admin_users_edit_page
    Admin::Users::EditPage.new
  end

  def admin_users_new_page
    Admin::Users::NewPage.new
  end

  def admin_categories_index_page
    Admin::Categories::IndexPage.new
  end

  def admin_interests_index_page
    Admin::Interests::IndexPage.new
  end

  def admin_interest_show_page
    Admin::Interests::ShowPage.new
  end
end
