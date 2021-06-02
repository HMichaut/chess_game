# frozen_string_literal: true

# Represents a generic chess piece
class ChessPiece
  attr_accessor :piece_posn

  def initialize(piece_posn)
    @piece_posn = piece_posn
  end
end

# Represents a white king
class WhiteKing < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern

  def initialize
    @symbol = ['2654'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([4, 0])
  end
end

# Represents a black king
class BlackKing < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern

  def initialize
    @symbol = ['265A'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([4, 7])
  end
end