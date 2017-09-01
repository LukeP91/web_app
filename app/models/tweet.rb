class Tweet < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :hash_tags, through: :tweets_hash_tags
  has_many :tweets_sources
  has_many :sources, through: :tweets_sources

  validates :user_name, :message, :tweet_id, presence: true

  scope :in_organization, ->(organization) { joins(:sources).where(sources: { organization_id: organization.id }) }

  def self.most_common_words(organization)
    messages_words_count(organization)
      .sort_by { |word, count| count }
      .reverse
  end

  private

  def self.messages_words_count(organization)
    Tweet.in_organization(organization)
      .map { |tweet| message_words_count(tweet.message) }
      .inject({}) do |count, message_count|
        count.merge(message_count) { |key, count_value, message_count_value| count_value + message_count_value }
      end
  end

  def self.message_words_count(message)
    words_count = {}
    message.split(' ').each do |word|
      word = unify(word)
      if words_count[word].present?
        words_count[word] += 1
      else
        words_count[word] = 1
      end
    end
    words_count
  end

  def self.unify(word)
    word.gsub(/[`, ']/, '').scan(/\w+/).first.downcase.singularize
  end
end
