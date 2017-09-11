class FacebookWrapper
  include HTTParty

  def initialize(organization)
    @access_token = organization.facebook_access_token
  end

  def post_on_wall(message)
    response = self.class.post('https://graph.facebook.com/v2.10/feed', query: { message: message, access_token: @access_token })
    response.ok? ? :ok : :expired_token
  end
end
