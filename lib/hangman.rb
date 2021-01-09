require 'rainbow'

class Hangman
  attr_accessor :secret_word, :guessed_word, :guessed_letters_list, :guessed_letters_display, :wrong_guesses

  def initialize
    choose_options
    start_game
  end

  def new_game
    wordlist = File.open('5desk.txt', 'r') { |file| file.readlines.map(&:strip) }
    # secret word are randomly sampled from the wordlist and to_char
    @secret_word = wordlist.sample.downcase.chars
    # the display is equals to '_' multiplies by the word length
    @guessed_word = ('_' * @secret_word.length).split('')
    # set parameters for new_game
    @wrong_guesses = 10
    @guessed_letters_list = []
    @guessed_letters_display = []
  end

  def choose_options
    puts "Choose a game option: 1) Start a new game
                      2) Load a saved game file"
    option = gets.chomp
    case option
    when '1' then new_game
    when '2' then load_game
    else puts 'Enter 1 or 2 to start the game...'
    end
  end

  def valid_input?(input, guessed_letters_list)
    if input.length != 1
      puts 'Too many letters, enter only one!'
      false
    elsif !input.match?(/[a-z]/)
      puts 'Not alphabet letter, please enter an alphabet letter!'
      false
    elsif guessed_letters_list.include?(input)
      puts "You've already guessed the letter, please enter another letter!"
      false
    else
      true
    end
  end

  def print_guessed_letters(guessed_letters_display)
    print 'Letters guessed: '
    guessed_letters_display.each do |char|
      print "#{char} "
    end
    print "\n"
  end

  # start the game
  def start_game
    until @secret_word == @guessed_word || @wrong_guesses.negative?
      # display current results
      @guessed_word.each do |char|
        print "#{char} "
      end

      puts "\nGuess a letter"
      guess = gets.chomp.downcase

      until valid_input?(guess, @guessed_letters_list)
        puts "\nGuess a letter"
        guess = gets.chomp.downcase
      end

      print "\n"

      if secret_word.include?(guess)
        puts Rainbow('Good guess!').green
        @guessed_letters_list << guess
        @guessed_letters_display << Rainbow(guess).green
        indexes = @secret_word.each_index.select { |i| @secret_word[i] == guess }
        indexes.each do |index|
          @guessed_word[index] = guess
        end
      else
        puts Rainbow('Wrong guess!').red
        @guessed_letters_list << guess
        @guessed_letters_display << Rainbow(guess).red
        @wrong_guesses -= 1
      end

      if @wrong_guesses.positive?
        puts "Wrong guesses left: #{@wrong_guesses}"
        print_guessed_letters(@guessed_letters_display)
        # print 'Letters guessed: '
        # @guessed_letters_display.each do |char|
        #   print "#{char} "
        # end
        # puts "\n"
      elsif @wrong_guesses.zero?
        puts 'Last chance, 0 guesses left'
        print_guessed_letters(@guessed_letters_display)
        # print 'Letters guessed: '
        # @guessed_letters_display.each do |char|
        #   print "#{char} "
        # end
        # puts "\n"
      else
        puts 'You lose...'
      end
    end
    puts 'You win the game!' if @secret_word == @guessed_word
    puts "The secret word is #{@secret_word.join}."
  end
end
