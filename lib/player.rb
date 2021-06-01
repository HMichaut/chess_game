# frozen_string_literal: true

# Represents a player
class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

# Represents a white player
class WhitePlayer < Player
  attr_accessor :chess_pieces_array

  def initialize
    super('White Player')
    @chess_pieces_array = [WhiteKing.new]
  end
end

# Represents a black player
class BlackPlayer < Player
  attr_accessor :chess_pieces_array

  def initialize
    super('Black Player')
    @chess_pieces_array = [BlackKing.new]
  end
end
