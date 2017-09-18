class TweetForm < Patterns::Form
  attribute :user_name, String
  attribute :message, String
  attribute :tweet_id, String
  attribute :tweet_created_at, DateTime
  attribute :sent_to_fb, Boolean
  attribute :hashtags, Array[String]

  validates :user_name, :message, :tweet_id, presence: true

  private

  def persist
    update_tweet && update_hash_tags
  end

  def update_tweet
    params = attributes.except(:hashtags).merge(organization: form_owner.organization)
    resource.update_attributes(params)
    resource.sources << form_owner
  end

  def update_hash_tags
    attributes[:hashtags].each do |hashtag|
      hash_tag = form_owner.organization.hash_tags.find_or_create_by(name: hashtag)
      resource.hash_tags << hash_tag
    end
  end
end
