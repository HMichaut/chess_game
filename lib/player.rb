# frozen_string_literal: true

# Represents a player
class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def find_king(input_board)
    input_board.content.each do |x_array|
      output = x_array.find { |item| (item.is_a?(BlackKing) || item.is_a?(WhiteKing)) && item.color == @color }
      return output unless output.nil?
    end
  end
end

# Represents a white player
class WhitePlayer < Player
  attr_accessor :chess_pieces_array
  attr_reader :color

  def initialize
    super('White Player')
    @chess_pieces_array = [WhiteKing.new([1, 2])]
    @color = 'white'
  end
end

# Represents a black player
class BlackPlayer < Player
  attr_accessor :chess_pieces_array
  attr_reader :color

  def initialize
    super('Black Player')
    @chess_pieces_array = [BlackKing.new([0, 0])]
    @color = 'black'
  end
end
