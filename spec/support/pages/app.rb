require_relative 'home'
require_relative 'login_page'

class App
  def home_page
    Home.new
  end

  def login_page
    LoginPage.new
  end
end
