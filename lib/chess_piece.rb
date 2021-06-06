# frozen_string_literal: true

# Represents a generic chess piece
class ChessPiece
  attr_accessor :piece_posn

  def initialize(piece_posn)
    @piece_posn = piece_posn
  end

  def full_vertical
    [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
     [0, -1], [0, -2], [0, -3], [0, -4], [0, -5], [0, -6], [0, -7]]
  end

  def full_horizontal
    [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
     [-1, 0], [-2, 0], [-3, 0], [-4, 0], [-5, 0], [-6, 0], [-7, 0]]
  end

  def full_diagonal
    [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
     [-1, 1], [-2, 2], [-3, 3], [-4, 4], [-5, 5], [-6, 6], [-7, 7],
     [1, -1], [2, -2], [3, -3], [4, -4], [5, -5], [6, -6], [7, -7],
     [-1, -1], [-2, -2], [-3, -3], [-4, -4], [-5, -5], [-6, -6], [-7, -7]]
  end

  def knight_move
    [[1, 2], [2, 1], [-1, - 2], [-2, -1],
     [-1, 2], [-2, 1], [1, -2], [2, -1]]
  end
end

# Represents a white king
class WhiteKing < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['265A'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    @color = 'white'
    super(piece_posn)
  end
end

class WhiteQueen < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['265B'.hex].pack('U')
    @move_patern = full_vertical + full_horizontal + full_diagonal
    @attack_patern = @move_patern
    @color = 'white'
    super(piece_posn)
  end
end

class WhiteRook < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['265C'.hex].pack('U')
    @move_patern = full_vertical + full_horizontal
    @attack_patern = @move_patern
    @color = 'white'
    super(piece_posn)
  end
end

class WhiteBishop < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['265D'.hex].pack('U')
    @move_patern = full_diagonal
    @attack_patern = @move_patern
    @color = 'white'
    super(piece_posn)
  end
end

class WhiteKnight < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['265E'.hex].pack('U')
    @move_patern = knight_move
    @attack_patern = @move_patern
    @color = 'white'
    super(piece_posn)
  end
end

class WhitePawn < ChessPiece
  attr_reader :symbol, :attack_patern, :color
  attr_accessor :move_patern

  def initialize(piece_posn)
    @symbol = ['265F'.hex].pack('U')
    @move_patern = [[0, 1], [0, 2]]
    @attack_patern =[[1, 1], [-1, 1]] 
    @color = 'white'
    super(piece_posn)
  end
end

# Represents a black king
class BlackKing < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['2654'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    @color = 'black'
    super(piece_posn)
  end
end

class BlackQueen < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['2655'.hex].pack('U')
    @move_patern = full_vertical + full_horizontal + full_diagonal
    @attack_patern = @move_patern
    @color = 'black'
    super(piece_posn)
  end
end

class BlackRook < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['2656'.hex].pack('U')
    @move_patern = full_vertical + full_horizontal
    @attack_patern = @move_patern
    @color = 'black'
    super(piece_posn)
  end
end


class BlackBishop < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['2657'.hex].pack('U')
    @move_patern = full_diagonal
    @attack_patern = @move_patern
    @color = 'black'
    super(piece_posn)
  end
end

class BlackKnight < ChessPiece
  attr_reader :symbol, :move_patern, :attack_patern, :color

  def initialize(piece_posn)
    @symbol = ['2658'.hex].pack('U')
    @move_patern = knight_move
    @attack_patern = @move_patern
    @color = 'black'
    super(piece_posn)
  end
end

class BlackPawn < ChessPiece
  attr_reader :symbol, :attack_patern, :color
  attr_accessor :move_patern

  def initialize(piece_posn)
    @symbol = ['2659'.hex].pack('U')
    @move_patern = [[0, -1], [0, -2]]
    @attack_patern = [[1, -1], [-1, -1]]
    @color = 'black'
    super(piece_posn)
  end
end
