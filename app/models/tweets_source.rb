class TweetsSource < ApplicationRecord
  belongs_to :tweet
  belongs_to :source
end
