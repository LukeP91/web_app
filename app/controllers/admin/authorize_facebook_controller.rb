class Admin::AuthorizeFacebookController < ApplicationController
  def update
    request.env['omniauth.auth']
    binding.pry
  end
end
