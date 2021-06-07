# frozen_string_literal: true

require_relative './player'
require_relative './chess_board'
require_relative './chess_piece'
require 'yaml'

# Represents a chess game
class ChessGame
  attr_reader :board, :player_ordered_list

  def initialize
    @player_ordered_list = [WhitePlayer.new, BlackPlayer.new]
    @board = ChessBoard.new.place_all_pieces_for_all_players(@player_ordered_list)
  end

  # Acquire player choice for posn, checks the output.
  def acquire_player_choice
    output = [-1, -1]
    alph_array = ('a'..'z').to_a
    until input_on_the_board?(output)
      puts 'input coordinate or save:'
      output_str = gets.chomp
      if output_str.length == 2 && output_str[0].count('a-z') == 1 && output_str[1].to_i.to_s == output_str[1]
        output = [alph_array.find_index(output_str[0]), output_str[1].to_i - 1]
      elsif output_str == 'save'
        open('chess_game.yaml', 'w') { |f| YAML.dump(self, f) }
      end
    end
    output
  end

  # Validates that the output is on the board
  def input_on_the_board?(posn)
    x = posn[0]
    y = posn[1]
    x.is_a?(Integer) && y.is_a?(Integer) && x.between?(0, (@board.width - 1)) && y.between?(0, (@board.height - 1))
  end

  # Switch player
  def switch_player
    @player_ordered_list.rotate!
  end

  # Consumes a posn and determine if it is within the area of the game board
  def check_if_valid(posn)
    posn[0].between?(0, @width - 1) && posn[1].between?(0, @height - 1)
  end

  # Determines if any piece has any move and if king is not attacked to check for tie game
  def tie_game?
    return false if check_situation?(@board, @player_ordered_list[0], @player_ordered_list[1])

    no_move_possible?(@player_ordered_list)
  end

  # Determines if player has won
  def player_won?
    return false unless check_situation?(@board, @player_ordered_list[0], @player_ordered_list[1])

    no_move_possible?(@player_ordered_list.rotate)
  end

  # Determines if any piece has any move
  def no_move_possible?(player_list)
    current_player = player_list[0]
    current_player.muster_all_pieces_for_player(@board).each do |chess_piece|
      attack_array = create_legal_moves_array(chess_piece, 'placeholder')
      move_array = create_legal_moves_array(chess_piece, nil).select { |posn| @board.content[posn[1]][posn[0]].nil? }

      return false if attack_array.any? { |posn| move_legal?(posn, chess_piece, @board.content[posn[1]][posn[0]], @board, player_list) }

      return false if move_array.any? { |posn| move_legal?(posn, chess_piece, nil, @board, player_list) }
    end
    true
  end

  # Determines if there is a check situation
  def check_situation?(input_board, current_player, opponent_player)
    opponent_king = opponent_player.find_king(input_board)
    chess_piece_array_to_be_considered = current_player.muster_all_pieces_for_player(input_board)
    chess_piece_array_to_be_considered.any? do |chess_piece|
      proc_array = create_legal_moves_array(chess_piece, opponent_king)
      proc_array.any? { |posn| posn == opponent_king.piece_posn && !input_board.obstruction?(chess_piece.piece_posn, opponent_king.piece_posn) }
    end
  end

  # Acquire player choice
  def acquire_piece_position
    puts "#{@player_ordered_list[0].name} select piece to be played:"
    acquire_player_choice
  end

  # Helper function to select piece
  def select_piece_from_posn(posn)
    x_posn = posn[0]
    y_posn = posn[1]
    @board.content[y_posn][x_posn]
  end

  # Select destination position
  def select_posn
    puts "#{@player_ordered_list[0].name} select destination position:"
    acquire_player_choice
  end

  # Move chess piece
  def move_piece(board_modified, piece_selected, posn_selected)
    castling_moves(posn_selected, piece_selected, board_modified.content[posn_selected[1]][posn_selected[0]], board_modified)
    board_modified.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]] = nil
    board_modified.content[posn_selected[1]][posn_selected[0]] = piece_selected
    piece_selected.piece_posn = posn_selected
    piece_selected.move_patern = [[0, 1]] if piece_selected.is_a?(WhitePawn)
    piece_selected.move_patern = [[0, -1]] if piece_selected.is_a?(BlackPawn)
  end

  # Check if player select own piece
  def selection_own_piece?(piece_selected)
    @player_ordered_list[0].chess_pieces_array.include?(piece_selected)
  end

  # Create and array of all legal moves
  def create_legal_moves_array(piece_selected, target_piece_selected)
    piece_posn = piece_selected.piece_posn
    if target_piece_selected.nil?
      move_array = piece_selected.move_patern.map { |move| [piece_posn[0] + move[0], piece_posn[1] + move[1]] }
    else
      move_array = piece_selected.attack_patern.map { |move| [piece_posn[0] + move[0], piece_posn[1] + move[1]] }
    end
    move_array.select { |move| input_on_the_board?(move) }
  end

  # Determines if the move selected is legal
  def move_legal?(posn_selected, piece_selected, target_piece_selected, input_board, player_list)
    current_player = player_list[0]
    opponent_player = player_list[1]

    return true if castling_moves?(posn_selected, piece_selected, target_piece_selected, input_board)

    own_piece_array = current_player.muster_all_pieces_for_player(@board)
    return false if own_piece_array.any? { |chess_piece| posn_selected == chess_piece.piece_posn} || !input_on_the_board?(posn_selected)

    legal_move_array = create_legal_moves_array(piece_selected, target_piece_selected)
    return false if input_board.obstruction?(posn_selected, piece_selected.piece_posn) || !legal_move_array.include?(posn_selected)

    board_save = Marshal.load( Marshal.dump(@board))
    duplicate_piece_selected = board_save.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]]
    move_piece(board_save, duplicate_piece_selected, posn_selected)
    !check_situation?(board_save, opponent_player, current_player)
  end

  # Determines if move is a legal castling move
  def castling_moves?(posn_selected, piece_selected, target_piece_selected, input_board)
    return false unless target_piece_selected.nil?
    return false if piece_selected.nil?

    piece_selected.is_a?(WhiteKing) || piece_selected.is_a?(BlackKing) && bottom_left_rook?(input_board, piece_selected, posn_selected)||
      bottom_right_rook?(input_board, piece_selected, posn_selected)  || top_left_rook?(input_board, piece_selected, posn_selected)  || 
      top_right_rook?(input_board, piece_selected, posn_selected)
  end

  def castling_move (king_selected, king_destination, rook_posn, rook_destination, input_board)
    input_rook = input_board.content[rook_posn[1]][rook_posn[0]]
    input_board.content[rook_posn[1]][rook_posn[0]] = nil
    input_board.content[king_selected.piece_posn[1]][king_selected.piece_posn[0]] = nil
    input_board.content[king_destination[1]][king_destination[0]] = king_selected
    input_board.content[rook_destination[1]][rook_destination[0]] = input_rook
    input_rook.piece_posn = rook_destination
    king_selected.piece_posn = king_destination
  end

  def bottom_left_rook?(input_board, piece_selected, posn_selected)
    input_board.content[0][0].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] &&
      posn_selected == [2, 0] && input_board.content[0][1].nil? && input_board.content[0][2].nil? &&
      input_board.content[0][3].nil?
  end

  def bottom_right_rook?(input_board, piece_selected, posn_selected)
    input_board.content[0][7].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] &&
      posn_selected == [6, 0] && input_board.content[0][5].nil? && input_board.content[0][6].nil?
  end

  def top_left_rook?(input_board, piece_selected, posn_selected)
    input_board.content[7][0].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] &&
      posn_selected == [2, 7] && input_board.content[7][1].nil? && input_board.content[7][2].nil? &&
      input_board.content[7][3].nil?
  end

  def top_right_rook?(input_board, piece_selected, posn_selected)
    input_board.content[7][7].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] &&
      posn_selected == [6, 7] && input_board.content[7][5].nil? && input_board.content[7][6].nil?
  end

  # Determines if move is a legal castling move
  def castling_moves(posn_selected, piece_selected, target_piece_selected, input_board)
    return false unless target_piece_selected.nil?
    if piece_selected.is_a?(WhiteKing)
      if bottom_left_rook?(input_board, piece_selected, posn_selected)
        castling_move(piece_selected, posn_selected, [0, 0], [3, 0], input_board)
      elsif bottom_right_rook?(input_board, piece_selected, posn_selected)
        castling_move(piece_selected, posn_selected, [7, 0], [5, 0], input_board)
      end
    elsif piece_selected.is_a?(BlackKing)
      if top_left_rook?(input_board, piece_selected, posn_selected)
        castling_move(piece_selected, posn_selected, [0, 7], [3, 7], input_board)
      elsif top_right_rook?(input_board, piece_selected, posn_selected)
        castling_move(piece_selected, posn_selected, [7, 7], [5, 7], input_board)
      end
    end
  end

  def select_piece(piece_selected = nil)
    until selection_own_piece?(piece_selected)
      piece_posn = acquire_piece_position
      piece_selected = select_piece_from_posn(piece_posn)
    end
    piece_selected
  end

  def move_piece_from_input(piece_selected = nil, target_piece_selected = nil, posn_selected = [-1, -1])
    until move_legal?(posn_selected, piece_selected, target_piece_selected, @board, @player_ordered_list)
      piece_selected = select_piece
      posn_selected = select_posn
      target_piece_selected = select_piece_from_posn(posn_selected)
    end
    move_piece(@board, piece_selected, posn_selected)
    unless target_piece_selected.nil?
      opponent_player_piece_array = @player_ordered_list[1].chess_pieces_array
      opponent_player_piece_array.delete(target_piece_selected)
    end
  end

  # Main play loop
  def play
    @board.print_board
    until tie_game?
      move_piece_from_input
      @board.print_board
      break if player_won?

      switch_player
    end
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('TIE!')
  end
end
