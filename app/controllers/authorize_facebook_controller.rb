class AuthorizeFacebookController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    if current_user.admin?
      current_user.organization.update_attributes(facebook_access_token: auth['credentials']['token'])
      redirect_to admin_sources_path
      flash[:notice] = t('admin.notices.facebook_key_loaded')
    end
  end
end
