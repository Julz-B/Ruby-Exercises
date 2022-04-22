# stock_picker.rb

def stock_picker(stock_arr)
  top_pick = []
  profit = 0

  stock_arr.each_with_index do |low_price, idx_low|
    stock_arr.each_with_index do |high_price, idx_high|
      if high_price - low_price > profit && idx_low < idx_high
        profit = high_price - low_price
        top_pick[0] = idx_low
        top_pick[1] = idx_high
      end
    end
  end
  p top_pick
end

stock_picker([17,3,6,9,15,8,6,1,10])
