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
  def acquire_player_choice ########################################################## add selection with letter + num
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

  def tie_game? ############################################################### to be finalized
    false
  end

  def player_won? ############################################################### to be finalized
    attacking_piece = inform_which_piece_create_check
    return false if attacking_piece.nil?

    return true

    king_cannot_be_saved?(attacking_piece)
  end

  def king_cannot_be_saved?(attacking_piece) ############################################################### to be finalized, add check for move
    opponent_player = @player_ordered_list[1]
    opponent_king = find_king(opponent_player)
    opponent_player.chess_pieces_array.each do |chess_piece|
      proc_array = create_legal_moves_array(chess_piece, chess_piece.piece_posn, attacking_piece)
      return false if proc_array.any? { |posn| posn == attacking_piece.piece_posn }
    end
    true
  end

  def inform_which_piece_create_check
    current_player = @player_ordered_list[0]
    opponent_player = @player_ordered_list[1]
    opponent_king = find_king(opponent_player)
    current_player.chess_pieces_array.each do |chess_piece|
      proc_array = create_legal_moves_array(chess_piece, chess_piece.piece_posn, opponent_king)
      return chess_piece if proc_array.any? { |posn| posn == opponent_king.piece_posn }
    end
    nil
  end

  def find_king(player)
    player.chess_pieces_array.find { |item| item.is_a?(BlackKing) || item.is_a?(WhiteKing)}
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

  def move_piece(piece_selected, posn_initial, posn_selected, target_piece_selected)
    x_posn_initial = posn_initial[0]
    y_posn_initial  = posn_initial[1]
    @board.content[y_posn_initial][x_posn_initial] = nil
    x_posn_selected = posn_selected[0]
    y_posn_selected = posn_selected[1]
    @board.content[y_posn_selected][x_posn_selected] = piece_selected
    piece_selected.piece_posn = posn_selected
    unless target_piece_selected.nil?
      opponent_player_piece_array = player_ordered_list[1].chess_pieces_array
      opponent_player_piece_array.delete(target_piece_selected)
    end
  end

  def selection_own_piece?(piece_selected)
    @player_ordered_list[0].chess_pieces_array.include?(piece_selected)
  end

  def create_legal_moves_array(piece_selected, piece_posn, target_piece_selected) ############# retirer piece_posn et extraire d ela pièce
    posn_x = piece_posn[0]
    posn_y = piece_posn[1]
    if target_piece_selected.nil?
      move_array = piece_selected.move_patern.map { |move| [posn_x + move[0], posn_y + move[1]] }
    else
      move_array = piece_selected.attack_patern.map { |move| [posn_x + move[0], posn_y + move[1]] }
    end
    move_array.select { |move| is_input_on_the_board?(move) }
  end

  def move_legal?(posn_selected, piece_selected, piece_posn, target_piece_selected) ######################### add a check for the king uncovering + add check if selected posn is own piece
    return false unless is_input_on_the_board?(posn_selected)

    legal_move_array = create_legal_moves_array(piece_selected, piece_posn, target_piece_selected)
    legal_move_array.include?(posn_selected)
  end

  def attack_piece(piece_selected, piece_posn, target_piece_selected, posn_selected)
    x_posn_initial = posn_initial[0]
    y_posn_initial = posn_initial[1]
    @board.content[y_posn_initial][x_posn_initial] = nil
    x_posn_selected = posn_selected[0]
    y_posn_selected = posn_selected[1]
    @board.content[y_posn_selected][x_posn_selected] = piece_selected
  end

  # Main play loop
  def play
    @board.print_board
    until tie_game?
      piece_selected = nil
      target_piece_selected = nil
      posn_selected = [-1, -1]
      piece_posn = [-1, -1]
      until move_legal?(posn_selected, piece_selected, piece_posn, target_piece_selected)
        piece_selected = nil
        until selection_own_piece?(piece_selected)
          piece_posn = acquire_piece_position
          piece_selected = select_piece(piece_posn)
        end
        posn_selected = select_posn
        target_piece_selected = select_piece(posn_selected)
      end
      move_piece(piece_selected, piece_posn, posn_selected, target_piece_selected)
      @board.print_board
      break if player_won?
      switch_player
    end
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('TIE!')
  end
end

ChessGame.new.play