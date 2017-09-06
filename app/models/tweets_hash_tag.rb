class TweetsHashTag < ApplicationRecord
  belongs_to :tweet
  belongs_to :hash_tag, counter_cache: :tweets_count
end
