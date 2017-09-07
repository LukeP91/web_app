class MostCommonWords < Patterns::Calculation
  private

  def result
    sorted_words_occurrences.take(limit)
  end

  def organization
    options.fetch(:organization)
  end

  def limit
    options.fetch(:limit)
  end

  def tweets
    options.fetch(:tweets, Tweet.in_organization(organization))
  end

  def sorted_words_occurrences
    words_occurrences
      .sort do |current_word_stats, next_word_stats|
        comparison = next_word_stats[:count] <=> current_word_stats[:count]
        comparison.zero? ? current_word_stats[:word] <=> next_word_stats[:word] : comparison
      end
  end

  def words_occurrences
    unified_words
      .group_by(&:itself)
      .map { |word, occurrences| { word: word, count: occurrences.size } }
  end

  def tweets_messages
    tweets
      .map(&:message)
      .map(&:split)
      .flatten
  end

  def unified_words
    tweets_messages
      .map { |word| unify(word) }
      .keep_if { |word| word.length >= 3 }
  end

  def unify(word)
    word.gsub(/(['`][sS][\W]*\Z|[\W])/, '').downcase
  end
end
