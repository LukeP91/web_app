class TweetsCollection < Patterns::Collection
  class Week
    def initialize(date_range, tweets)
      @date_range = date_range
      @tweets = tweets
    end

    def title
      "#{date_range.first.strftime('%d.%m.%Y')} - #{date_range.last.strftime('%d.%m.%Y')}"
    end

    def each(&block)
      days_with_tweets.each(&block)
    end

    private

    attr_reader :date_range, :tweets

    def days_with_tweets
      @days_with_tweets ||= days.map do |day|
        tweets = @tweets.where(tweet_created_at: day)
        Day.new(day, tweets)
      end
    end

    def days
      tweets.order(:tweet_created_at).map(&:tweet_created_at).uniq
    end
  end

  class Day
    Tweet = Struct.new(:id, :date, :status)

    def initialize(date, tweets)
      @date = date
      @tweets = tweets
    end

    def title
      @date.strftime('%d.%m.%Y').to_s
    end

    def each(&block)
      tweets.each(&block)
    end

    private

    def tweets
      @tweets.map do |tweet|
        Tweet.new(
          tweet.tweet_id,
          tweet.tweet_created_at.strftime('%d.%m.%Y'),
          tweet.sent_to_fb
        )
      end
    end
  end

  private

  def collection
    group_by_weeks
  end

  def group_by_weeks
    weeks.map do |week|
      tweets = subject.where(tweet_created_at: week)
      Week.new(week, tweets)
    end
  end

  def weeks
    subject.order(:tweet_created_at).map do |tweet|
      tweet.tweet_created_at.beginning_of_week..tweet.tweet_created_at.end_of_week
    end.uniq
  end
end
