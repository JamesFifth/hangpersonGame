class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  # HangpersonGame constructor with one word parameter
  # @word = word, @guesses = '', @wrong_guesses = ''
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(character)
    
    # if (nil, empty, non-character) raise exception
    if !character || character.empty? || !character.match(/[A-Za-z]/)
      raise ArgumentError
    end
    
    # transfer into downcase character
    character.downcase!
    
    # @guesses.index(character) means character already in guesses
    # @wrong_guesses.index(character) menas character in wrong guess
    if @guesses.index(character) || @wrong_guesses.index(character)
      return false
    end
    # word.index(character) means character are in word
    word.index(character) ? @guesses << character : @wrong_guesses << character
  end

  def word_with_guesses
    displayed = ''
    @word.each_char do |character|
      
      # traverse the word, check one by one
      @guesses.index(character) ? displayed << character : displayed << '-'
    end
    displayed # the current guess out word result
  end

  # check game status
  def check_win_or_lose
    # three status: lose, win and play
    if @wrong_guesses.length >= 7 # lose if guess wrong for 7 times
      return :lose
    end
    if !word_with_guesses.index('-') # win if all letters are guess right
      return :win
    end
    :play # other wise no win no lose means game is playing now
  end

  # class function to get the word for each game
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri, {}).body
  end
end
