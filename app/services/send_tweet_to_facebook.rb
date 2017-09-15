class SendTweetToFacebook < Pattern::ServicePattern
  def initialize(tweet:, organization:)
    @tweet = tweet
    @organization = organization
  end

  def call
    response = FacebookWrapper.new(organization).post_on_wall(tweet.message)
    if response == :ok
      tweet.update_attributes(send_to_fb: true)
    end
  end

  private

  attr_reader :organization, :tweet
end
