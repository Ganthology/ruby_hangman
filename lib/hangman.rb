require 'rainbow'
wordlist = File.open('5desk.txt', 'r') { |file| file.readlines.map(&:strip) }

secret_word = wordlist.sample.downcase.chars
word_length = secret_word.length

puts secret_word.inspect
# initialize the guesses display
display = []
word_length.times do 
  display << '_'
end

def valid_input(input, guessed_letters)
  if input.length != 1
    puts 'Too many letters, enter only one!'
    false
  elsif !input.match?(/[a-z]/)
    puts 'Not alphabet letter, please enter an alphabet letter!'
    false
  elsif guessed_letters.include?(input)
    puts "You've already guessed the letter, please enter another letter!"
    false
  else
    true
  end
  # return true if input.match?(/[a-z]/) && input.length == 1
end

# start the game
wrong_guesses = 10
guessed_letters = []
guessed_letters_display = []
until secret_word == display || wrong_guesses.negative?
  # display current results
  display.each do |char|
    print "#{char} "
  end

  puts "\nGuess a letter"
  guess = gets.chomp.downcase

  until valid_input(guess, guessed_letters)
    puts "\nGuess a letter"
    guess = gets.chomp.downcase
  end

  if secret_word.include?(guess)
    puts Rainbow('Good guess!').green
    guessed_letters << guess
    guessed_letters_display << Rainbow(guess).green
    indexes = secret_word.each_index.select { |i| secret_word[i] == guess }
    indexes.each do |index|
      display[index] = guess
    end
  else
    puts Rainbow('Wrong guess!').red
    guessed_letters << guess
    guessed_letters_display << Rainbow(guess).red
    wrong_guesses -= 1
  end

  puts "Wrong guesses left: #{wrong_guesses}" if wrong_guesses.positive?

  print 'Letters guessed: '
  guessed_letters_display.each do |char|
    print "#{char} "
  end
  puts "\n\n"
end
