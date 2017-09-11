class Admin::AuthorizeFacebookController < ApplicationController
  def new
    redirect_to '/auth/facebook'
  end

  def update
    auth = request.env['omniauth.auth']
    binding.pry
  end
end
