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

  def obstruction?(posn_initial, posn_end)
    if move_one_square?(posn_initial, posn_end) || move_knight?(posn_initial, posn_end)
      false
    elsif move_horizontal?(posn_initial, posn_end)
      horizontal_obstruction?(posn_initial, posn_end)
    elsif move_vertical?(posn_initial, posn_end)
      vertical_obstruction?(posn_initial, posn_end)
    elsif move_diagonal?(posn_initial, posn_end)
      diagonal_obstruction?(posn_initial, posn_end)
    end
  end

  def move_one_square?(posn_initial, posn_end)
    (posn_initial[0] - posn_end[0]).abs <= 1 && (posn_initial[1] - posn_end[1]).abs <= 1
  end

  def move_knight?(posn_initial, posn_end)
    x_variation = (posn_initial[0] - posn_end[0]).abs
    y_variation = (posn_initial[1] - posn_end[1]).abs
    (x_variation == 1 && y_variation == 2) || (x_variation == 2 && y_variation == 1)
  end

  def move_horizontal?(posn_initial, posn_end)
    posn_initial[1] == posn_end[1]
  end

  def horizontal_obstruction?(posn_initial, posn_end)
    x_initial = posn_initial[0]
    x_end = posn_end[0]
    y_initial = posn_initial[1]

    if x_initial < x_end
      ((x_initial + 1)..(x_end - 1)).any? { |x_val| !@content[y_initial][x_val].nil? }
    elsif x_initial > x_end
      ((x_end + 1)..(x_initial - 1)).any? { |x_val| !@content[y_initial][x_val].nil? }
    end
  end

  def move_vertical?(posn_initial, posn_end)
    posn_initial[0] == posn_end[0]
  end

  def vertical_obstruction?(posn_initial, posn_end)
    y_initial = posn_initial[1]
    y_end = posn_end[1]
    x_initial = posn_initial[0]

    if y_initial < y_end
      ((y_initial + 1)..(y_end - 1)).any? { |y_val| !@content[y_val][x_initial].nil? }
    elsif y_initial > y_end
      ((y_end + 1)..(y_initial - 1)).any? { |y_val| !@content[y_val][x_initial].nil? }
    end
  end

  def move_diagonal?(posn_initial, posn_end)
    x_variation = (posn_initial[0] - posn_end[0]).abs
    y_variation = (posn_initial[1] - posn_end[1]).abs
    (x_variation == y_variation)
  end

  def diagonal_obstruction?(posn_initial, posn_end)
    x_initial = posn_initial[0]
    y_initial = posn_initial[1]
    x_end = posn_end[0]
    y_end = posn_end[1]
    if x_initial < x_end && y_initial < y_end
      ((x_initial + 1)..(x_end - 1)).zip((y_initial + 1)..(y_end - 1)).any? { |x_val, y_val| !@content[y_val][x_val].nil? }
    elsif x_initial > x_end && y_initial > y_end
      ((x_end + 1)..(x_initial - 1)).zip((y_end + 1)..(y_initial - 1)).any? { |x_val, y_val| !@content[y_val][x_val].nil? }
    elsif x_initial < x_end && y_initial > y_end
      ((x_initial + 1)..(x_end - 1)).zip((y_end + 1)..(y_initial - 1)).any? { |x_val, y_val| !@content[y_val][x_val].nil? }
    elsif x_initial > x_end && y_initial < y_end
      ((x_end + 1)..(x_initial - 1)).zip(((y_initial + 1)..(y_end - 1)).to_a.reverse).any? { |x_val, y_val| !@content[y_val][x_val].nil? }
    end
  end
end