# frozen_string_literal: true

class ChessPiece
  attr_reader :starting_posn

  def initialize(starting_posn)
    @starting_posn = starting_posn
  end
end

class WhiteKing < ChessPiece
  attr_reader :symbol

  def initialize
    @symbol = ['2654'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 0]])
  end
end

class BlackKing < ChessPiece
  attr_reader :symbol

  def initialize
    @symbol = ['265A'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 7]])
  end
end