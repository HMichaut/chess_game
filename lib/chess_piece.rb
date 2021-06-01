# frozen_string_literal: true

# Represents a generic chess piece
class ChessPiece
  attr_reader :starting_posn

  def initialize(starting_posn)
    @starting_posn = starting_posn
  end
end

# Represents a white king
class WhiteKing < ChessPiece
  attr_reader :symbol, :move_patern

  def initialize
    @symbol = ['2654'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 0]])
  end
end

# Represents a black king
class BlackKing < ChessPiece
  attr_reader :symbol

  def initialize
    @symbol = ['265A'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 7]])
  end
end