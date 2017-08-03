class LoginPage < SitePrism::Page
  element :email_field, '#user_email'
  element :password_field, '#user_password'
  element :login_button, "input[name='commit']"
end
