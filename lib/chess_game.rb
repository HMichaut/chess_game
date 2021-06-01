# frozen_string_literal: true

require_relative './player'
require_relative './chess_board'
require_relative './chess_piece'

class ChessGame
  attr_reader :board

  def initialize
    @player_ordered_list = [WhitePlayer.new, BlackPlayer.new]
    @board = ChessBoard.new.place_all_pieces_for_all_players(@player_ordered_list)
  end

  # Acquire player choice for posn, checks the output.
  def acquire_player_choice
    output = [-1, -1]
    until is_input_on_the_board?(output)
      puts 'input x coordinate:'
      output[0] = gets.chomp.to_i
      puts 'input y coordinate:'
      output[1] = gets.chomp.to_i
    end
    output
  end

  # Validates that the output is on the board
  def is_input_on_the_board?(posn)
    x = posn[0]
    y = posn[1]
    x.is_a?(Integer) && y.is_a?(Integer) && x.between?(0, (@board.width - 1)) && y.between?(0, (@board.height - 1))
  end

  # Switch player
  def switch_player
    @player_ordered_list.rotate!
  end

  # Posn -> Boolean
  # Consumes a posn and determine if it is within the area of the game board
  def check_if_valid(posn)
    posn[0].between?(0, @width - 1) && posn[1].between?(0, @height - 1)
  end

  def player_won? ############## to be finalized
    false
  end

  def acquire_piece_position
    puts "#{@player_ordered_list[0].name} select piece to be played:"
    acquire_player_choice
  end

  def select_piece(posn)
    x_posn = posn[0]
    y_posn = posn[1]
    @board.content[y_posn][x_posn]
  end

  def select_posn ############## to be finalized
    puts "#{@player_ordered_list[0].name} select destination position:"
    acquire_player_choice
  end

  def move_piece(piece_selected, posn_initial, posn_selected) ############## to be finalized
    x_posn_initial = posn_initial[0]
    y_posn_initial  = posn_initial[1]
    @board.content[y_posn_initial][x_posn_initial] = nil
    x_posn_selected = posn_selected[0]
    y_posn_selected = posn_selected[1]
    @board.content[y_posn_selected][x_posn_selected] = piece_selected
  end

  # Main play loop
  def play
    @board.print_board
    until player_won?
      piece_posn = acquire_piece_position
      piece_selected = select_piece(piece_posn)
      posn_selected = select_posn
      move_piece(piece_selected, piece_posn, posn_selected)
      @board.print_board
      switch_player
      break
    end
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('TIE!')
  end
end

ChessGame.new.play