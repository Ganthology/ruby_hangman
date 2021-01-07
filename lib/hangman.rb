require 'rainbow'
wordlist = File.open('5desk.txt', 'r') { |file| file.readlines.map(&:strip) }

secret_word = wordlist.sample.downcase.chars
word_length = secret_word.length

puts secret_word.inspect
display = []
word_length.times do 
  display << '_'
end

# first time display for user to know how many places
display.each do |char|
  print "#{char} "
end

# start the game
wrong_guesses = 10
guesses = []
until secret_word == display || wrong_guesses < 0
  puts "\nguess a letter"
  guess = gets.chomp.downcase

  if secret_word.include?(guess)
    puts Rainbow('Good guess!').green
    guesses << Rainbow(guess).green
    indexes = secret_word.each_index.select { |i| secret_word[i] == guess }
    indexes.each do |index|
      display[index] = guess
    end
  else
    puts Rainbow('Wrong guess!').red
    guesses << Rainbow(guess).red
    wrong_guesses -= 1
  end
  puts "Wrong guesses left: #{wrong_guesses}"
  print 'Letters guessed: '
  guesses.each do |char|
    print "#{char} "
  end

  print "\n"
  # display current results
  display.each do |char|
    print "#{char} "
  end
end
