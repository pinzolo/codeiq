# coding: utf-8

# 0～9までの数字が最も早くすべて現れるのは、10桁が0-9で構築されている場合
# 整数部を含む場合、小数点を含め最初から11文字の全ての文字がユニークならばOK
# 整数部を含まない場合、小数点以下の10文字の全ての文字がユニークならばOK

i = 2
containing_integer = nil
only_decimal = nil
while true
  sqrt = Math.sqrt(i)
  if sqrt.to_s[0, 11].chars.uniq.size == 11
    containing_integer = i
  end
  if sqrt.to_s[sqrt.to_i.to_s.size + 1, 10].chars.uniq.size == 10
    puts sqrt.to_s[sqrt.to_i.to_s.size + 1, 10]
    only_decimal = i
  end
  break if containing_integer && only_decimal
  i += 1
end
puts "#{containing_integer} : #{Math.sqrt(containing_integer)}"
puts "#{only_decimal} : #{Math.sqrt(only_decimal)}"
