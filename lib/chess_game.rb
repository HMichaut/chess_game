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
    alph_array = ('a'..'z').to_a
    until is_input_on_the_board?(output)
      puts 'input coordinate:'
      output_str = gets.chomp
      if output_str.length == 2 && output_str[0].count('a-z') == 1 && output_str[1].to_i.to_s == output_str[1]
        output[0] = alph_array.find_index(output_str[0])
        output[1] = output_str[1].to_i - 1
      end
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

  def tie_game? ############################################################### to be finalized
    false
  end

  def player_won? ############################################################### to be finalized
    attacking_piece = inform_which_piece_create_check(@board, @player_ordered_list[0], @player_ordered_list[1])
    return false if attacking_piece.nil?

    king_cannot_be_saved?(attacking_piece)
  end

  def king_cannot_be_saved?(attacking_piece) ############################################################### to be finalized, add check for move
    opponent_player = @player_ordered_list[1]
    opponent_king = opponent_player.find_king(@board)
    board_save = Marshal.load( Marshal.dump(@board))
    opponent_player.chess_pieces_array.each do |chess_piece|
      attack_array = create_legal_moves_array(chess_piece, attacking_piece).select { |posn| posn == attacking_piece.piece_posn}
      unless attack_array.nil?
        board_save = Marshal.load( Marshal.dump(@board))
        move_piece(board_save, chess_piece, chess_piece.piece_posn, opponent_king.piece_posn, opponent_king)
        attacking_piece = inform_which_piece_create_check(board_save, @player_ordered_list[0], @player_ordered_list[1])
        return false if attacking_piece.nil?
      end
      move_array = create_legal_moves_array(chess_piece, nil)
      unless move_array.nil?
        move_array.each do |posn|
          board_save = Marshal.load( Marshal.dump(@board))
          move_piece(board_save, chess_piece, chess_piece.piece_posn, posn, nil)
          attacking_piece = inform_which_piece_create_check(board_save, @player_ordered_list[0], @player_ordered_list[1])
          return false if attacking_piece.nil?
        end
      end
    end
    true
  end

  def muster_all_pieces_for_player(input_board, checked_player)
    piece_array = []
    checked_color = checked_player.color
    input_board.content.each do |x_array|
      piece_array += x_array.select { |item| !item.nil? && item.color == checked_color }
    end
    piece_array
  end

  def inform_which_piece_create_check(input_board, current_player, opponent_player)
    opponent_king = opponent_player.find_king(input_board)
    chess_piece_array_to_be_considered = muster_all_pieces_for_player(input_board, current_player)
    chess_piece_array_to_be_considered.each do |chess_piece|
      proc_array = create_legal_moves_array(chess_piece, opponent_king)
      return chess_piece if proc_array.any? { |posn| posn == opponent_king.piece_posn }
    end
    nil
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

  def select_posn
    puts "#{@player_ordered_list[0].name} select destination position:"
    acquire_player_choice
  end

  def move_piece(board_modified, piece_selected, posn_initial, posn_selected, target_piece_selected) ########## virer posn initial
    x_posn_initial = posn_initial[0]
    y_posn_initial  = posn_initial[1]
    board_modified.content[y_posn_initial][x_posn_initial] = nil
    x_posn_selected = posn_selected[0]
    y_posn_selected = posn_selected[1]
    board_modified.content[y_posn_selected][x_posn_selected] = piece_selected
    piece_selected.piece_posn = posn_selected
  end

  def selection_own_piece?(piece_selected)
    @player_ordered_list[0].chess_pieces_array.include?(piece_selected)
  end

  def create_legal_moves_array(piece_selected, target_piece_selected)
    piece_posn = piece_selected.piece_posn
    posn_x = piece_posn[0]
    posn_y = piece_posn[1]
    if target_piece_selected.nil?
      move_array = piece_selected.move_patern.map { |move| [posn_x + move[0], posn_y + move[1]] }
    else
      move_array = piece_selected.attack_patern.map { |move| [posn_x + move[0], posn_y + move[1]] }
    end
    move_array.select { |move| is_input_on_the_board?(move) }
  end

  def move_legal?(posn_selected, piece_selected, target_piece_selected)

    own_piece_array = muster_all_pieces_for_player(@board, @player_ordered_list[0])
    return false if own_piece_array.any? { |chess_piece| posn_selected == chess_piece.piece_posn}


    return false unless is_input_on_the_board?(posn_selected)

    legal_move_array = create_legal_moves_array(piece_selected, target_piece_selected)
    return false unless legal_move_array.include?(posn_selected)

    board_save = Marshal.load( Marshal.dump(@board))
    duplicate_piece_selected = board_save.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]]
    move_piece(board_save, duplicate_piece_selected, duplicate_piece_selected.piece_posn, posn_selected, target_piece_selected)
    attacking_piece = inform_which_piece_create_check(board_save, @player_ordered_list[1], @player_ordered_list[0])
    attacking_piece.nil?
  end

  # Main play loop
  def play
    @board.print_board
    until tie_game?
      piece_selected = nil
      target_piece_selected = nil
      posn_selected = [-1, -1]
      piece_posn = [-1, -1]
      until move_legal?(posn_selected, piece_selected, target_piece_selected)
        piece_selected = nil
        until selection_own_piece?(piece_selected)
          piece_posn = acquire_piece_position
          piece_selected = select_piece(piece_posn)
        end
        posn_selected = select_posn
        target_piece_selected = select_piece(posn_selected)
      end
      move_piece(@board, piece_selected, piece_posn, posn_selected, target_piece_selected)
      unless target_piece_selected.nil?
        opponent_player_piece_array = player_ordered_list[1].chess_pieces_array
        opponent_player_piece_array.delete(target_piece_selected)
      end
      @board.print_board
      break if player_won?
      switch_player
    end
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('TIE!')
  end
end

ChessGame.new.play