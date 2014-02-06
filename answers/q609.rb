# coding: utf-8
module StrawMatPattern
  # 座標クラス
  class Point# {{{
    attr_reader :x, :y, :sides

    def initialize(x, y)
      @x, @y = x, y
    end

    # 隣同士かどうか
    def near?(other)
      ((other.x - @x).abs == 1 && other.y == @y) || (other.x == @x && (other.y - @y).abs == 1)
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
  end# }}}

  # 辺クラス
  class Side# {{{
    attr_reader :point1, :point2

    def initialize(point_a, point_b)
      # 原点に近い方を始点とする
      if point_a.x < point_b.x
        @point1, @point2 = point_a, point_b
      elsif point_a.x > point_b.x
        @point1, @point2 = point_b, point_a
      else
        if point_a.y < point_b.y
          @point1, @point2 = point_a, point_b
        elsif point_a.y > point_b.y
          @point1, @point2 = point_b, point_a
        else
          raise "same point"
        end
      end
    end

    def ==(other)
      @point1 == other.point1 && @point2 == other.point2
    end

    def eql?(other)
      self == other
    end

    def hash
      [@point1, @point2].hash
    end
  end# }}}

  # 単位正方形クラス
  class Square# {{{
    attr_reader :base_point, :points, :sides

    def initialize(base_point)
      @base_point = base_point
      @points = [base_point, Point.new(base_point.x, base_point.y + 1), Point.new(base_point.x + 1, base_point.y + 1), Point.new(base_point.x + 1, base_point.y)]
      @sides = [Side.new(@points[0], @points[1]), Side.new(@points[1], @points[2]), Side.new(@points[2], @points[3]), Side.new(@points[3], @points[0])]
    end

    # 隣同士かどうか
    def near?(other)
      @base_point.near?(other.base_point)
    end

    def ==(other)
      @base_point == other.base_point
    end

    def eql?(other)
      self == other
    end

    def hash
      @base_point.hash
    end
  end# }}}

  # 畳クラス
  class StrawMat# {{{
    attr_reader :square1, :square2

    def initialize(square1, square2)
      raise "cannot create" unless square1.near?(square2)
      @square1, @square2 = square1, square2
    end

    def points
      @points ||= square1.points | square2.points
    end

    def sides
      # 共通辺は辺として存在しない
      @sides ||= (square1.sides | square2.sides) - (square1.sides & square2.sides)
    end

    # 縦に敷かれているか
    def vertical?
      square1.base_point.x == square2.base_point.x
    end

    # 横に敷かれているか
    def horizontal?
      square1.base_point.y == square2.base_point.y
    end
  end# }}}

  # 敷き詰めシミュレータ
  class Simulator# {{{
    def initialize(v, h)
      @x, @y = h, v
      @valid_straw_mats = []
    end

    def simulate
      remain_base_points = base_points.dup
      lay_straw_mat([], remain_base_points)
      display
    end

    private
    # 畳を敷き詰める
    def lay_straw_mat(straw_mats, remain_base_points)
      if remain_base_points.empty?
        # 基点を使いきれた場合、祝儀敷きであれば有効である
        @valid_straw_mats << straw_mats if valid_layout?(straw_mats)
      else
        # 新規に一枚畳を敷く
        base_point = remain_base_points.shift
        near_points = remain_base_points.select { |point| point.near?(base_point) }
        unless near_points.empty?
          near_points.each do |point|
            lay_straw_mat(straw_mats + [StrawMat.new(Square.new(base_point), Square.new(point))], remain_base_points - [point])
          end
        end
      end
    end

    def display
      text_matrixs = @valid_straw_mats.map { |straw_mats| text_matrix(straw_mats) }
      displayed = []
      text_matrixs.each do |matrix|
        # 180度転回させたものは除外する
        lotated = matrix.map(&:reverse).reverse.map(&:join).join("\n").strip
        unless displayed.include?(lotated)
          displayed << matrix.map(&:join).join("\n").strip
          puts displayed.last
          puts "-" * 20
        end
      end
    end

    # 文字表現変換
    def text_matrix(straw_mats)
      point_matrix.map do |points|
        points.map do |point|
          if base_points.include?(point)
            straw_mat = straw_mats.find { |sm| sm.square1.base_point == point || sm.square2.base_point == point }
            straw_mat.vertical? ? "｜" : "―"
          end
        end
      end
    end

    def point_matrix
      @point_matrix ||= (0..@y).map do |y|
        (0..@x).map { |x| Point.new(x, y) }
      end
    end

    def all_points
      @all_points ||= point_matrix.flatten
    end

    # 内部座標（外周にない座標）のリスト
    def inner_points
      @inner_points ||= all_points.select { |point| (point.x != 0 && point.x != @x) || (point.y != 0 || point.y != @y) }
    end

    # 畳の基点となりうる座標リスト
    def base_points
      @base_points ||= all_points.select { |point| point.x != @x && point.y != @y }
    end

    # 敷詰め方が祝儀敷きになっているかどうか
    def valid_layout?(straw_mats)
      sides = straw_mats.map(&:sides).inject(:|)
      # 内部座標に対し4本の辺が生えていなければ、十字に交わっていない
      inner_points.all? do |point|
        4 > sides.count { |side| side.point1 == point || side.point2 == point }
      end
    end
  end# }}}
end

StrawMatPattern::Simulator.new(4, 7).simulate
puts "#" * 24
StrawMatPattern::Simulator.new(5, 6).simulate
