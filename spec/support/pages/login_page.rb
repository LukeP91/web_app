class LoginPage < SitePrism::Page
  set_url '/users/sign_in'
  element :email_field, '#user_email'
  element :password_field, '#user_password'
  element :login_button, "input[name='commit']"

  def login(user)
    email_field.set user.email
    password_field.set user.password
    login_button.click
  end
end
