class AddFacebookAccessTokenToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :facebook_access_token, :string
  end
end
