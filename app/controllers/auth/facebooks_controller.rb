class Auth::FacebooksController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    if current_user.admin?
      current_user.organization.update_attributes(
        facebook_access_token: auth['credentials']['token'],
        facebook_access_token_expired: false
      )

      redirect_to admin_sources_path
      flash[:notice] = t('admin.notices.facebook_key_loaded')
    end
  end
end
