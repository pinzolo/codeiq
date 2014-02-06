# coding: utf-8

class Numbers
  attr_reader :change_count

  def initialize(numbers)
    @change_count = 0
    @numbers = numbers
    @fixed_flags = @numbers.map { |n| n == 1 }
    puts @numbers.inspect
  end

  # 終了判別
  def finish?
    # 全組み合わせの GCD, LCM が変化無しかどうかを判別
    @numbers.permutation(2).all? { |a, b| eq_gcdlcm?(a, b) }
  end

  def change!
    # 固定されていない数字から最小公倍数が最大となる組み合わせに対し変換を行う
    max_lcm = unfixed_numbers.permutation(2).map { |a, b| a.lcm(b) }.max
    num1, num2 = unfixed_numbers.permutation(2).find { |a, b| a.lcm(b) == max_lcm }
    gcd = num1.gcd(num2)
    lcm = num1.lcm(num2)
    idx1 = @numbers.index(num1)
    idx2 = @numbers.index(num2)
    # 1 もしくは非固定数の LCM に対して等しくなればそれ以上処理しないため固定化する
    fix(idx1) if gcd == 1
    fix(idx2) if lcm == current_lcm
    @numbers[idx1] = gcd
    @numbers[idx2] = lcm
    @change_count += 1
    puts "#{@numbers.inspect} (#{idx1}: #{num1} -> #{gcd}, #{idx2}: #{num2} -> #{lcm})"
  end

  private
  def fix(index)
    @fixed_flags[index] = true
  end

  def fixed?(index)
    @fixed_flags[index]
  end

  # 固定されていない数一覧
  def unfixed_numbers
    @numbers.select.with_index { |_, i| !fixed?(i) }
  end

  # 2つの数の GCD, LCM が元の数と同じかどうかを判別
  def eq_gcdlcm?(a, b)
    [a.gcd(b), a.lcm(b)].sort == [a, b].sort
  end

  # 固定されていない数全体に対する LCM
  def current_lcm
    lcm(unfixed_numbers)
  end

  # 指定の数字全体に対して LCM を計算する
  def lcm(numbers)
    return numbers.first if numbers.size == 1

    lcms = numbers.permutation(2).map { |a, b| a.lcm(b) }
    lcm(lcms.uniq)
  end
end

numbers = Numbers.new((1..6).to_a)
until numbers.finish?
  numbers.change!
end
puts numbers.change_count

=begin
以下実行結果の出力
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 380] (18: 19 -> 1, 19: 20 -> 380)
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 1, 18, 1, 6460] (16: 17 -> 1, 19: 380 -> 6460)
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 14, 15, 16, 1, 18, 1, 83980] (12: 13 -> 1, 19: 6460 -> 83980)
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 12, 1, 14, 15, 16, 1, 18, 1, 923780] (10: 11 -> 1, 19: 83980 -> 923780)
[1, 2, 3, 4, 5, 6, 7, 8, 1, 10, 1, 12, 1, 14, 15, 16, 1, 18, 1, 8314020] (8: 9 -> 1, 19: 923780 -> 8314020)
[1, 2, 3, 4, 5, 6, 1, 8, 1, 10, 1, 12, 1, 14, 15, 16, 1, 18, 1, 58198140] (6: 7 -> 1, 19: 8314020 -> 58198140)
[1, 2, 3, 4, 5, 6, 1, 8, 1, 10, 1, 12, 1, 14, 15, 4, 1, 18, 1, 232792560] (15: 16 -> 4, 19: 58198140 -> 232792560)
[1, 2, 3, 4, 5, 6, 1, 8, 1, 10, 1, 12, 1, 1, 210, 4, 1, 18, 1, 232792560] (13: 14 -> 1, 14: 15 -> 210)
[1, 2, 3, 4, 5, 6, 1, 2, 1, 10, 1, 12, 1, 1, 840, 4, 1, 18, 1, 232792560] (7: 8 -> 2, 14: 210 -> 840)
[1, 2, 3, 4, 5, 6, 1, 2, 1, 10, 1, 12, 1, 1, 6, 4, 1, 2520, 1, 232792560] (14: 840 -> 6, 17: 18 -> 2520)
[1, 2, 3, 4, 1, 6, 1, 2, 1, 10, 1, 60, 1, 1, 6, 4, 1, 2520, 1, 232792560] (4: 5 -> 1, 11: 12 -> 60)
[1, 2, 1, 4, 1, 6, 1, 2, 1, 30, 1, 60, 1, 1, 6, 4, 1, 2520, 1, 232792560] (2: 3 -> 1, 9: 10 -> 30)
[1, 2, 1, 2, 1, 6, 1, 2, 1, 60, 1, 60, 1, 1, 6, 4, 1, 2520, 1, 232792560] (3: 4 -> 2, 9: 30 -> 60)
[1, 2, 1, 2, 1, 2, 1, 2, 1, 60, 1, 60, 1, 1, 6, 12, 1, 2520, 1, 232792560] (5: 6 -> 2, 15: 4 -> 12)
14
=end
