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
    puts 'ERROR'
  end

  def muster_all_pieces_for_player(input_board)
    piece_array = []
    checked_color = @color
    input_board.content.each do |x_array|
      piece_array += x_array.select { |item| !item.nil? && item.color == checked_color }
    end
    piece_array
  end
end

# Represents a white player
class WhitePlayer < Player
  attr_accessor :chess_pieces_array
  attr_reader :color

  def initialize
    super('White Player')
    @chess_pieces_array = [WhiteKing.new([4, 0]), WhitePawn.new([0, 1]), WhitePawn.new([1, 1]), WhitePawn.new([2, 1]),
                           WhitePawn.new([3, 1]), WhitePawn.new([4, 1]), WhitePawn.new([5, 1]), WhitePawn.new([6, 1]),
                           WhitePawn.new([7, 1]), WhiteQueen.new([3, 0]), WhiteRook.new([0, 0]), WhiteRook.new([7, 0]),
                           WhiteBishop.new([2, 0]), WhiteBishop.new([5, 0]), WhiteKnight.new([1, 0]), 
                           WhiteKnight.new([6, 0])]
    @color = 'white'
  end
end

# Represents a black player
class BlackPlayer < Player
  attr_accessor :chess_pieces_array
  attr_reader :color

  def initialize
    super('Black Player')
    @chess_pieces_array = [BlackKing.new([4, 7]), BlackPawn.new([0, 6]), BlackPawn.new([1, 6]), BlackPawn.new([2, 6]),
                           BlackPawn.new([3, 6]), BlackPawn.new([4, 6]), BlackPawn.new([5, 6]), BlackPawn.new([6, 6]),
                           BlackPawn.new([7, 6]), BlackQueen.new([3, 7]), BlackRook.new([0, 7]), BlackRook.new([7, 7]),
                           BlackBishop.new([2, 7]), BlackBishop.new([5, 7]), BlackKnight.new([1, 7]), 
                           BlackKnight.new([6, 7])]
    @color = 'black'
  end
end
