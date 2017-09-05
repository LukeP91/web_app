class TweetsSource < ApplicationRecord
  belongs_to :tweet
  belongs_to :source

  validates :tweet, :source, presence: true
end
