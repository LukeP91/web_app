class HashTag < ApplicationRecord
  has_many :tweets_hash_tags
  has_many :tweets, through: :tweets_hash_tags
end
