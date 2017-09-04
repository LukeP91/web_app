class MostCommonWords < Patterns::Calculation
  private

  def result
    sorted_words_occurrences
  end

  def organization
    options.fetch(:organization)
  end

  def sorted_words_occurrences
    words_occurrences
      .sort do |a, b|
        comp = b[1] <=> a[1]
        comp.zero? ? a[0] <=> b[0] : comp
      end
  end

  def words_occurrences
    tweets_messages
      .map { |word| unify(word) }
      .group_by { |word| word }
      .map { |word| [word[0], word[1].size] }
  end

  def tweets_messages
    Tweet.in_organization(organization).map(&:message).map(&:split).flatten
  end

  def unify(word)
    word.gsub(/[`'][sS]\Z/, '')
      .gsub(/[`']/, '')
      .scan(/\w+/)
      .first
      .downcase
  end
end
