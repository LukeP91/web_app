class TweetsCollection < Patterns::Collection
  private

  def collection
    group_by_weeks
  end

  def group_by_weeks
    weeks = subject.order(:tweet_created_at).map do |tweet|
      tweet.tweet_created_at.beginning_of_week..tweet.tweet_created_at.end_of_week
    end.uniq
    weeks.map do |week|
      tweets = subject.where(tweet_created_at: week)
      week = Week.new(week, tweets)
    end
  end

  class Week
    def initialize(date_range, tweets)
      @date_range = date_range
      @tweets = tweets
    end

    def title
      "#{date_range.first.strftime('%d.%m.%Y')} - #{date_range.last.strftime('%d.%m.%Y')}"
    end

    def each(&block)
      @days ||= group_by_days
      @days.each(&block)
    end

    private

    attr_reader :date_range, :tweets

    def group_by_days
      days = tweets.order(:tweet_created_at).map(&:tweet_created_at).uniq
      days.map do |day|
        tweets = @tweets.where(tweet_created_at: day)
        day = Day.new(day, tweets)
      end
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
      @tweets.map { |tweet| Tweet.new(tweet.tweet_id, tweet.tweet_created_at.strftime('%d.%m.%Y'), tweet.sent_to_fb) }
    end
  end
end
