# bubble_sort.rb
require 'pry-byebug'

def bubble_sort(array)
  sorted_array = array
  arr_total = array.count - 1
  idx = 0
  idx2 = idx + 1
  temp_holder = 0
  sorted = 0
  # binding.pry
  arr_total.times do 
    if sorted_array[idx] > sorted_array[idx2]
      temp_holder = sorted_array[idx2]
      sorted_array[idx2] = sorted_array[idx]
      sorted_array[idx] = temp_holder
      sorted += 1
    end
    idx += 1
    idx2 += 1
  end
  # binding.pry
  if sorted > 0
    bubble_sort(sorted_array)
  end
  if sorted == 0
    p sorted_array
  end  
end

num_array = [4,3,78,2,0,2]

bubble_sort(num_array)

num_array2 = [32, 2, 100, 72, 4, 82, 8, 9, 12, 3, 3, 2, 5, 7, 90]

bubble_sort(num_array2)

