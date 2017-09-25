class SendTweetToFacebook < Pattern::ServicePattern
  def initialize(user:, tweet_id:, organization:)
    @user = user
    @tweet_id = tweet_id
    @organization = organization
  end

  private

  def call
    tweet = Tweet.in_organization(organization).find(tweet_id)
    raise Pundit::NotAuthorizedError if !Pundit.policy(user, tweet).send_to_facebook?
    if FacebookWrapper.new(organization).post_on_wall(tweet.message) == :ok
      tweet.update_attributes(sent_to_fb: true)
    end
  end

  attr_reader :organization, :tweet_id, :user
end
