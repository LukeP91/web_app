class AddFacebookAccessTokenExpiredToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :facebook_access_token_expired, :boolean, default: false
  end
end
