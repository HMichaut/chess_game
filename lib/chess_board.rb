# frozen_string_literal: true

# Represents a chess board
class ChessBoard
  attr_accessor :content
  attr_reader :width, :height

  def initialize
    @width = 8
    @height = 8
    @content = board_creation(@width, @height)
  end

  def board_creation(width, height)
    Array.new(height) { Array.new(width, nil) }
  end

  def place_all_pieces_for_all_players(player_array)
    player_array.each do |player|
      place_all_pieces_for_one_player(player.chess_pieces_array)
    end
    self
  end

  def place_all_pieces_for_one_player(input_pieces_array)
    input_pieces_array.each do |chess_piece|
      place_piece(chess_piece, chess_piece.piece_posn)
    end
  end

  def place_piece(piece, posn)
    posn_x = posn[0]
    posn_y = posn[1]
    @content[posn_y][posn_x] = piece
  end

  def print_board
    input_board = @content.transpose
    puts "\n"
    7.downto(0) do |i|
      puts '    +---+---+---+---+---+---+---+---+'
      # print "  #{i+1} |"     final print
      print "  #{i} |"
      input_board.each do |column|
        column[i].nil? ? print('   ') : print(" #{column[i].symbol} ")
        print '|'
      end
      puts "\n"
    end
    puts '    +---+---+---+---+---+---+---+---+'
    # puts '      a   b   c   d   e   f   g   h'   final print
    puts '      0   1   2   3   4   5   6   7'
  end
end