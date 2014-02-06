# coding: utf-8

# 座標クラス
class Point
  attr_reader :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def eql?(other)
    self == other
  end

  def hash
    [@x, @y].hash
  end
end

# 一歩クラス
class Step
  attr_reader :start_point, :end_point

  def initialize(start_point, end_point)
    @start_point, @end_point = start_point, end_point
  end

  def ==(other)
    @start_point == other.start_point && @end_point == other.end_point
  end

  def eql?(other)
    self == other
  end

  def hash
    [@start_point, @end_point].hash
  end
end

# 経路クラス
class Route
  attr_reader :points, :steps

  def initialize
    @points = [Point.new(0, 0)]
    @steps = []
  end

  # 指定方向に進む
  def step!(direction)
    current_point = @points.last
    next_point = direction == :h ? Point.new(current_point.x + 1, current_point.y)
                                 : Point.new(current_point.x, current_point.y + 1)
    @points << next_point
    @steps << Step.new(current_point, next_point)
  end

  # 同じ辺を通っているかどうか
  def include_same_step?(another)
    (@steps & another.steps).size > 0
  end

  def ==(other)
    @steps == other.steps
  end

  def eql?(other)
    self == other
  end

  def hash
    @steps.hash
  end
end

# 辺の長さ
side_length = 6

# 片道の経路一覧を作成する(:h -> 横, :v -> 縦)
routes = [:h, :v].repeated_permutation(side_length * 2).with_object([]) do |directions, list|
  # 縦・横が半々の場合のみゴールに到着する経路である
  next if directions.count { |d| d == :h } != side_length
  # ゴールまで進ませた経路を登録
  list << directions.each_with_object(Route.new) { |d, r| r.step!(d) }
end

# 往路・復路は方向が違うだけと考えられるため、重複しない二つの経路を抽出し、
# 同じ辺を通っていなかった場合、往路・復路の候補となる
puts routes.permutation(2).count { |go, back| !go.include_same_step?(back) }
