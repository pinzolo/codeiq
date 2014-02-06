# coding: utf-8
# 配列を初期化
def init_array(n)
  [1.upto(n).to_a]
end

# m回分割する
def split_times_for(arr, m)
  split_count = 0
  [].tap do |new_arr|
    arr.each do |item|
      if item.size == 1
        new_arr.push(item)
      else
        if split_count == m
          # 1回で切ることができる回数に達している
          new_arr.push(item)
        else
          new_arr.push(*split_array(item))
          split_count += 1
        end
      end
    end
  end
end

# 配列を半分に分割する
def split_array(arr)
  idx = arr.size / 2
  [arr[0, idx], arr[idx, arr.size]]
end

def calc_split_times(n, m)
  arr = init_array(n)
  count = 0
  # 全ての要素が長さ1になるまで繰り返す
  while arr.any? { |item| item.size > 1 }
    arr = split_times_for(arr, m)
    count += 1
  end
  count
end

#puts calc_split_times(8, 3)
puts calc_split_times(20, 3)
puts calc_split_times(100, 5)
