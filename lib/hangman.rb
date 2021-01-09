require 'rainbow'
require 'json'

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

  def save_game
    Dir.mkdir('saved_files') unless Dir.exist?('saved_files')
    print 'Enter the name of the saved game: '
    filename = gets.chomp
    saved_file = "saved_files/#{filename}.json"
    File.open(saved_file, 'w') do |file|
      file.puts JSON.dump({
                            secret_word: @secret_word,
                            guessed_word: @guessed_word,
                            guessed_letters_list: @guessed_letters_list,
                            guessed_letters_display: @guessed_letters_display,
                            wrong_guesses: @wrong_guesses
                          })
    end
    print "\n"
  end

  def load_game(filename)
    # check correct filename
    until File.exist?(filename)
      puts 'The filename is incorrect...'
      print 'Please enter a correct saved game filename: '
      input = gets.chomp
      filename = "saved_files/#{input}.json"
    end
    data = JSON.parse(File.read(filename))
    @secret_word = data['secret_word']
    @guessed_word = data['guessed_word']
    @guessed_letters_list = data['guessed_letters_list']
    @guessed_letters_display = data['guessed_letters_display']
    @wrong_guesses = data['wrong_guesses']
  end

  def check_save_game
    print "\nDo you want to save the game?(press Y to save)"
    save = gets.chomp
    if save.downcase == 'y'
      save_game
      puts 'The game has been saved...'
      true
    else
      puts 'The game is continuing...'
      false
    end
  end

  def check_include_secret_word(guess)
    if secret_word.include?(guess)
      puts Rainbow('Good guess!').green
      @guessed_letters_list << guess
      @guessed_letters_display << Rainbow(guess).green
      indexes = @secret_word.each_index.select { |i| @secret_word[i] == guess }
      indexes.each { |index| @guessed_word[index] = guess }
    else
      puts Rainbow('Wrong guess!').red
      @guessed_letters_list << guess
      @guessed_letters_display << Rainbow(guess).red
      @wrong_guesses -= 1
    end
  end

  def choose_options
    puts "Choose a game option: 1) Start a new game
                      2) Load a saved game file"
    option = gets.chomp
    case option
    when '1'
      new_game
    when '2'
      if Dir.exist?('saved_files')
        puts Rainbow.('The saved game list').orange
        Dir.glob('saved_files/*').each { |filename| puts Rainbow(filename).orange }
        puts Rainbow('*').orange * 20
        print 'Enter the saved file name: '
        filename = gets.chomp
        load_game("saved_files/#{filename}.json")
      else
        puts 'There is no saved file...'
        puts 'Starting a new game...'
        new_game
      end
    else puts 'Enter 1 or 2 to start the game...'
    end
    print "\n"
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
    guessed_letters_display.each { |char| print "#{char} " }
    print "\n"
  end

  def wrong_guesses_message(wrong_guesses)
    if wrong_guesses.positive?
      puts Rainbow("Wrong guesses left: #{wrong_guesses}").yellow
    elsif wrong_guesses.zero?
      puts Rainbow('Last chance, 0 guesses left').red
    end
  end

  # start the game
  def start_game
    puts Rainbow('*').yellow * 20
    until @secret_word == @guessed_word || @wrong_guesses.negative?
      wrong_guesses_message(@wrong_guesses)
      # display current results
      @guessed_word.each { |char| print "#{char} " }

      print "\nGuess a letter: "
      guess = gets.chomp.downcase

      until valid_input?(guess, @guessed_letters_list)
        print "\nGuess a letter: "
        guess = gets.chomp.downcase
      end

      check_include_secret_word(guess)
    
      print_guessed_letters(@guessed_letters_display)

      return if check_save_game

      puts Rainbow('*').yellow * 20
    end
    # Announce the results, Win or Lose
    puts 'You win the game!' if @secret_word == @guessed_word
    puts 'You lose!' if @secret_word != @guessed_word

    puts "The secret word is #{@secret_word.join}."
  end
end
