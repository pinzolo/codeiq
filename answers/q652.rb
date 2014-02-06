# coding: utf-8
# 今回は4桁が対象のため四則演算＋なにもしない演算子から3つを組み合わせるもののうち、乗算を含むものを候補とする
  # 乗算なしで4桁になる可能性があるのは 99m + n かつ m + n >= 10 の場合のみ
  # 999m + n が 2000 を越すことはありえないので、命題を満たす可能性があるのは n = 1 の場合のみ
  # n = 1 の場合に4桁となるのは m = 9 の場合のみ
  # m = 9, n = 1 の場合 999 + 1 = 1000 → 0001 != 1999
  # よって、乗算がない場合は除外してよい
ops_list = [" + ", " - ", " * ", " / ", ""].repeated_permutation(3).select { |ops| ops.include?(" * ") }

start_number = 1000
end_number = 9999
answers = start_number.upto(end_number).map(&:to_s).each_with_object([]) do |number, valids|
  ops_list.each do |ops|
    expression = number[0] + ops[0] + number[1] + ops[1] + number[2] + ops[2] + number[3]
    # そのまま演算すると除算時に小数部が切り捨てられてしまうので小数として計算する
    result = eval(expression.gsub(/(\d+)/) { |num| num.to_f.to_s })
    # NaN および無限大は除外
    next if result.nan? || result.infinite?
    result_number = result.to_i
    # 結果が整数でないものは除外
    next if result_number != result
    # 範囲外を除外
    next if result_number < start_number || end_number < result_number
    valids << number if number.to_s.chars.reverse == result_number.to_s.chars
  end
end
puts answers.join(",")
