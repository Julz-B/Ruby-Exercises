# substrings.rb

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

def substrings(words, dictionary_array)
  words_array = words.downcase.split(' ')
  word_count = Hash.new(0)
  words_array.each do |word|
    dictionary_array.each do |dict_word|
      word_count[dict_word] += 1 if word.include?(dict_word)
    end
  end
  p word_count
end

substrings("Howdy partner, sit down! How's it going?", dictionary)
