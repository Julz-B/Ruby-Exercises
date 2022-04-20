# caesar_cipher.rb

def caesar_cipher(string, shift_factor)
  lowcase_arr = ("a".."z").to_a
  upcase_arr = ("A".."Z").to_a
  cipher_array = []
  string.each_char do |char|
    # check if char is lowercase and shift accordingly
    if lowcase_arr.include?(char)
      cipher_idx = (lowcase_arr.find_index(char) + shift_factor) % 26
      cipher_array << lowcase_arr[cipher_idx]
    elsif upcase_arr.include?(char)
    # check if char is uppercase and shift accoringly  
      cipher_idx = (upcase_arr.find_index(char) + shift_factor) % 26
      cipher_array << lowcase_arr[cipher_idx]
    # if not a letter, return char  
    else cipher_array.push(char)
    end
  end
  cipher_array.join('')
end

puts caesar_cipher("abc DEFG! hijk? lmn...",2)
puts caesar_cipher("abc DEFG! hijk? lmn...",26)
puts caesar_cipher("abc DEFG! hijk? lmn...",10)
