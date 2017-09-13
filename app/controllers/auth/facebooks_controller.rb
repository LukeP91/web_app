class Auth::FacebooksController < ApplicationController
  def show
    authorize :facebook, :show?
  end

  def callback
    authorize :facebook, :callback?
    auth = request.env['omniauth.auth']
    current_user.organization.update_attributes(
      facebook_access_token: auth['credentials']['token'],
      facebook_access_token_expired: false
    )

    redirect_to admin_sources_path
    flash[:notice] = t('admin.notices.facebook_key_loaded')
  end
end
