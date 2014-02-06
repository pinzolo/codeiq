# coding: utf-8
num = 10
answer = nil
while answer.nil?
  if num.to_s == num.to_s.reverse && num.to_s(8) == num.to_s(8).reverse && num.to_s(2) == num.to_s(2).reverse
    answer = num
  end
  num += 1
end

puts answer

a = []
b = []
c = []
(10..1000).each do |i|
  a << i if i.to_s == i.to_s.reverse
  b << i if i.to_s(8) == i.to_s(8).reverse
  c << i if i.to_s(2) == i.to_s(2).reverse
end

puts "#{a.size} : #{a.inspect}"
puts "#{b.size} : #{b.inspect}"
puts "#{c.size} : #{c.inspect}"
