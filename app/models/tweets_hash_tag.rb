class TweetsHashTag < ApplicationRecord
  belongs_to :tweet
  belongs_to :hash_tag
end
