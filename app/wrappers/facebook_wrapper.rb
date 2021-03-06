class FacebookWrapper
  include HTTParty

  FEED_URL = 'https://graph.facebook.com/v2.10/feed'.freeze

  def initialize(organization)
    @organization = organization
    @access_token = organization.facebook_access_token
  end

  def post_on_wall(message)
    return :expired_token if organization.facebook_access_token_expired

    response = self.class.post(
      FEED_URL,
      query: { message: message, access_token: access_token }
    )
    if response.ok?
      :ok
    else
      organization.update_attributes(facebook_access_token_expired: true)
      :expired_token
    end
  end

  private

  attr_reader :organization, :access_token
end
