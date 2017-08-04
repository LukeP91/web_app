module Sections
  class UserForm < SitePrism::Section
    element :email_field, '#user_email'
    element :first_name_field, '#user_first_name'
    element :last_name_field, '#user_last_name'
    element :gender_field, '#user_gender'
    element :age_field, '#user_age'
    element :interests_field, '#user_interest_ids'
    element :confirm_button, "input[name='commit']"
  end
end
