# frozen_string_literal: true

class ChessGame
  attr_reader :board

  def initialize
    @white_chess_pieces_array = [WhiteKing.new]
    @black_chess_pieces_array = [BlackKing.new]
    @board = place_all_pieces(@black_chess_pieces_array, place_all_pieces(@white_chess_pieces_array, ChessBoard.new))
  end

  def place_piece(piece, posn, input_chess_board)
    posn_x = posn[0]
    posn_y = posn[1]
    input_chess_board.board[posn_y][posn_x] = piece
  end

  def place_all_pieces(input_pieces_array, input_chess_board)
    input_pieces_array.each do |chess_piece_type|
      chess_piece_type.starting_posn.each do |chess_piece_posn|
        place_piece(chess_piece_type, chess_piece_posn, input_chess_board)
      end
    end
    input_chess_board
  end

  # Posn -> Boolean
  # Consumes a posn and determine if it is within the area of the game board
  def check_if_valid(posn)
    posn[0].between?(0, @width - 1) && posn[1].between?(0, @height - 1)
  end
end

class ChessPieces
  attr_reader :starting_posn

  def initialize(starting_posn)
    @starting_posn = starting_posn
  end

  def move_to_square ########################TBD
  end

  def attack_square ########################TBD
  end
end

class WhiteKing < ChessPieces
  attr_reader :symbol

  def initialize
    @symbol = ['2654'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 0]])
  end
end

class BlackKing < ChessPieces
  attr_reader :symbol

  def initialize
    @symbol = ['265A'.hex].pack('U')
    @move_patern = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    @attack_patern = @move_patern
    super([[4, 7]])
  end
end

class ChessBoard
  attr_accessor :board, :starting_posn
  attr_reader :width, :height

  def initialize
    @width = 8
    @height = 8
    @board = board_creation(@width, @height)
  end

  def board_creation(width, height)
    Array.new(height) {Array.new(width, nil)}
  end

  def print_board
    input_board = @board.transpose
    puts "\n"
    7.downto(0) do |i|
      puts '    +---+---+---+---+---+---+---+---+'
      print "  #{i+1} |"
      input_board.each do |column|
        column[i].nil? ? print('   ') : print(" #{column[i].symbol} ")
        print '|'
      end
      puts "\n"
    end
    puts '    +---+---+---+---+---+---+---+---+'
    puts '      a   b   c   d   e   f   g   h'
  end
end

test_game = ChessGame.new

p test_game.board
test_game.board.print_board
