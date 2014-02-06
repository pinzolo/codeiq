# coding: utf-8
# 首クラス
class Poem
  attr_reader :first_phrase, :last_phrase
  attr_accessor :first_uniq_count, :last_uniq_count

  def initialize(first_phrase, last_phrase)
    @first_phrase, @last_phrase = first_phrase, last_phrase
  end

  def self.load
    [].tap do |list|
      File.open("hyakunin.csv", "r:utf-8") do |f|
        f.gets # ヘッダ読み飛ばし
        while line = f.gets
          values = line.split(",")
          list << Poem.new(values[3], values[4])
        end
      end
    end
  end
end

module Enumerable
  # 前のアイテムを保持した each
  def each_with_prev
    prev = nil
    each do |item|
      yield(prev, item)
      prev = item
    end
  end
end

poems = Poem.load
# 上の句、下の句に対する一意文字数を設定
[:first, :last].each do |type|
  phrase_method_name = "#{type}_phrase"
  uniq_count_method_name = "#{type}_uniq_count"

  sorted_poems = poems.sort_by { |poem| poem.send(phrase_method_name) }
  sorted_poems.each_with_prev do |prev, current|
    next unless prev

    prev.send(phrase_method_name).chars.each_with_index do |char, index|
      # 最初の文字から比較し、異なる文字になった場合に一意な文字数となる
      if current.send(phrase_method_name)[index] != char
        char_index = index + 1
        current.send("#{uniq_count_method_name}=", char_index)
        if prev.send(uniq_count_method_name).nil? || char_index > prev.send(uniq_count_method_name)
          # 既に設定されている一意文字数よりも大きい場合再度設定する
          prev.send("#{uniq_count_method_name}=", char_index)
        end
        break
      end
    end
  end
end

# debug
#puts poems.sort_by(&:first_phrase).map { |poem| "#{poem.first_uniq_count} - #{poem.last_uniq_count} : #{poem.first_phrase} #{poem.last_phrase}" }

puts poems.inject(0) { |sum, poem| sum + poem.first_uniq_count + poem.last_uniq_count }

