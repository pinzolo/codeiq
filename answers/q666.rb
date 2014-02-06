# coding: utf-8
# マスクラス
class Cell# {{{
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

  def to_s
    "[#{x}, #{y}]"
  end

  def inspect
    to_s
  end
end# }}}

# 将棋板クラス
class Board# {{{
  CELL_ORIGIN = 1
  CELL_SIZE = 9
  CELL_MATRIX = CELL_ORIGIN.upto(CELL_SIZE).map do |y|
    CELL_ORIGIN.upto(CELL_SIZE).map do |x|
      Cell.new(x, y)
    end
  end
  ALL_CELLS = CELL_MATRIX.inject(:+)

  def self.row_cells(y)
    ALL_CELLS.select { |cell| cell.y == y }
  end

  def self.col_cells(x)
    ALL_CELLS.select { |cell| cell.x == x }
  end

  def self.tilted_cells(base_cell, positive_gradient = true)
    if positive_gradient
      ALL_CELLS.select { |cell| cell.x - base_cell.x == base_cell.y - cell.y }
    else
      ALL_CELLS.select { |cell| cell.x - base_cell.x == cell.y - base_cell.y }
    end
  end
end# }}}

# 駒クラス
class Piece
  attr_reader :cell
  def initialize(cell)
    @cell = cell
  end

  # 実際に移動可能なマス
  def possible_cells(other_piece = nil)
    if other_piece
      available_cells - interrupted_cells(other_piece)
    else
      available_cells
    end
  end

  # 駒が移動可能なマス
  def available_cells
    raise "Not implement"
  end

  # 本来なら移動可能だが、他の駒に遮られて移動不可能なマス
  def interrupted_cells(piece)
    raise "Not implement"
  end
end

# 飛車クラス
class Hisha < Piece
  def available_cells
    @available_cells ||= (Board.row_cells(@cell.y) | Board.col_cells(@cell.x)) - [@cell]
  end

  def interrupted_cells(piece)
    if piece.cell.x == @cell.x
      if piece.cell.y > @cell.y
        available_cells.select { |cell| cell.y >= piece.cell.y }
      else
        available_cells.select { |cell| cell.y <= piece.cell.y }
      end
    elsif piece.cell.y == @cell.y
      if piece.cell.x > @cell.x
        available_cells.select { |cell| cell.x >= piece.cell.x }
      else
        available_cells.select { |cell| cell.x <= piece.cell.x }
      end
    else
      []
    end
  end
end

# 角クラス
class Kaku < Piece
  def available_cells
    @available_cells ||= (Board.tilted_cells(@cell) | Board.tilted_cells(@cell, false)) - [@cell]
  end

  def interrupted_cells(piece)
    if piece.cell.x - @cell.x == @cell.y - piece.cell.y
      if piece.cell.y < @cell.y
        available_cells.select { |cell| cell.y <= piece.cell.y && cell.x >= piece.cell.x }
      else
        available_cells.select { |cell| cell.y >= piece.cell.y && cell.x <= piece.cell.x }
      end
    elsif piece.cell.x - @cell.x == piece.cell.y - @cell.y
      if piece.cell.y < @cell.y
        available_cells.select { |cell| cell.y <= piece.cell.y && cell.x <= piece.cell.x }
      else
        available_cells.select { |cell| cell.y >= piece.cell.y && cell.x >= piece.cell.x }
      end
    else
      []
    end
  end
end

total = 0
Board::ALL_CELLS.each do |h_cell|
  hisha = Hisha.new(h_cell)
  Board::ALL_CELLS.each do |k_cell|
    next if h_cell == k_cell
    kaku = Kaku.new(k_cell)
    cells = hisha.possible_cells(kaku) | kaku.possible_cells(hisha)
    total += cells.size
  end
end
puts total
