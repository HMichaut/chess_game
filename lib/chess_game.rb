# frozen_string_literal: true

require_relative './player'
require_relative './chess_board'
require_relative './chess_piece'

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
    until is_input_on_the_board?(output)
      puts 'input coordinate:'
      output_str = gets.chomp
      if output_str.length == 2 && output_str[0].count('a-z') == 1 && output_str[1].to_i.to_s == output_str[1]
        output = [alph_array.find_index(output_str[0]), output_str[1].to_i - 1]
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

  # Consumes a posn and determine if it is within the area of the game board
  def check_if_valid(posn)
    posn[0].between?(0, @width - 1) && posn[1].between?(0, @height - 1)
  end

  # Determines if any piece has any move and if king is not attacked to check for tie game
  def tie_game?
    attacking_piece = inform_which_piece_create_check(@board, @player_ordered_list[0], @player_ordered_list[1])
    return false unless attacking_piece.nil?

    no_move_possible?
  end

  # Determines if any piece has any move
  def no_move_possible?
    current_player = @player_ordered_list[0]
    current_player.muster_all_pieces_for_player(@board).each do |chess_piece|

      # Creation of move arrays
      attack_array = create_legal_moves_array(chess_piece, 'placeholder')
      move_array = create_legal_moves_array(chess_piece, nil)
      next if move_array.nil?

      # Loop for attacking pieces
      attack_array.each do |posn|
        board_save = Marshal.load(Marshal.dump(@board))
        chess_piece_selected = board_save.content[chess_piece.piece_posn[1]][chess_piece.piece_posn[0]]
        target_piece_selected = board_save.content[posn[1]][posn[0]]
        next if target_piece_selected.nil? || board_save.obstruction?(chess_piece.piece_posn, posn)

        destination_element = board_save.content[posn[1]][posn[0]]
        move_piece(board_save, chess_piece_selected, posn)
        next if !destination_element.nil? && destination_element.color == current_player.color

        attacking_piece = inform_which_piece_create_check(board_save, @player_ordered_list[1], @player_ordered_list[0])
        return false if attacking_piece.nil?
      end

      # Loop for moving pieces 
      move_array.each do |posn_move|
        board_save = Marshal.load(Marshal.dump(@board))
        chess_piece_selected = board_save.content[chess_piece.piece_posn[1]][chess_piece.piece_posn[0]]
        destination_element = board_save.content[posn_move[1]][posn_move[0]]
        next if board_save.obstruction?(chess_piece_selected.piece_posn, posn_move) || !destination_element.nil?

        move_piece(board_save, chess_piece_selected, posn_move)
        attacking_piece = inform_which_piece_create_check(board_save, @player_ordered_list[1], @player_ordered_list[0])
        return false if attacking_piece.nil?
      end
    end
    true
  end

  # Determines if player has won
  def player_won?
    attacking_piece = inform_which_piece_create_check(@board, @player_ordered_list[0], @player_ordered_list[1])
    return false if attacking_piece.nil?

    king_cannot_be_saved?(attacking_piece)
  end

  # Determines if king can be saved by moving a piece
  def king_cannot_be_saved?(attacking_piece)
    opponent_player = @player_ordered_list[1]
    opponent_player.muster_all_pieces_for_player(@board).each do |chess_piece|

      # Move arrays creation
      attack_array = create_legal_moves_array(chess_piece, attacking_piece).select { |posn| posn == attacking_piece.piece_posn }
      move_array = create_legal_moves_array(chess_piece, nil)
      next if move_array.nil?

      # Attack loop
      unless attack_array.nil?
        board_save = Marshal.load(Marshal.dump(@board))
        chess_piece_selected = board_save.content[chess_piece.piece_posn[1]][chess_piece.piece_posn[0]]
        next if board_save.obstruction?(chess_piece.piece_posn, attacking_piece.piece_posn)

        move_piece(board_save, chess_piece_selected, attack_array[0]) unless attack_array.empty?

        attacking_piece_returned = inform_which_piece_create_check(board_save, @player_ordered_list[0], @player_ordered_list[1])
        return false if attacking_piece_returned.nil?
      end

      # Move loop
      move_array.each do |posn|
        board_save = Marshal.load(Marshal.dump(@board))
        chess_piece_selected = board_save.content[chess_piece.piece_posn[1]][chess_piece.piece_posn[0]]
        destination_element = board_save.content[posn[1]][posn[0]]
        next if board_save.obstruction?(chess_piece.piece_posn, posn) || !destination_element.nil?

        move_piece(board_save, chess_piece_selected, posn)
        attacking_piece_returned = inform_which_piece_create_check(board_save, @player_ordered_list[0], @player_ordered_list[1])
        return false if attacking_piece_returned.nil?
      end
    end
    true
  end

  # Determines if there is a check and if yes returns the piece
  def inform_which_piece_create_check(input_board, current_player, opponent_player)
    opponent_king = opponent_player.find_king(input_board)
    chess_piece_array_to_be_considered = current_player.muster_all_pieces_for_player(input_board)
    chess_piece_array_to_be_considered.each do |chess_piece|
      proc_array = create_legal_moves_array(chess_piece, opponent_king)
      return chess_piece if proc_array.any? { |posn| posn == opponent_king.piece_posn && !input_board.obstruction?(chess_piece.piece_posn, opponent_king.piece_posn) }
    end
    nil
  end

  # Acquire player choice
  def acquire_piece_position
    puts "#{@player_ordered_list[0].name} select piece to be played:"
    acquire_player_choice
  end

  # Helper function to select piece
  def select_piece(posn)
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
    move_array.select { |move| is_input_on_the_board?(move) }
  end

  # Determines if the move selected is legal
  def move_legal?(posn_selected, piece_selected, target_piece_selected, input_board)
    return true if castling_moves?(posn_selected, piece_selected, target_piece_selected, input_board)

    own_piece_array = @player_ordered_list[0].muster_all_pieces_for_player(@board)
    return false if own_piece_array.any? { |chess_piece| posn_selected == chess_piece.piece_posn} || !is_input_on_the_board?(posn_selected)

    legal_move_array = create_legal_moves_array(piece_selected, target_piece_selected)
    return false if input_board.obstruction?(posn_selected, piece_selected.piece_posn) || !legal_move_array.include?(posn_selected)

    board_save = Marshal.load( Marshal.dump(@board))
    duplicate_piece_selected = board_save.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]]
    move_piece(board_save, duplicate_piece_selected, posn_selected)
    inform_which_piece_create_check(board_save, @player_ordered_list[1], @player_ordered_list[0]).nil?
  end

    # Determines if move is a legal castling move
    def castling_moves?(posn_selected, piece_selected, target_piece_selected, input_board)
      return false unless target_piece_selected.nil?
  
      if piece_selected.is_a?(WhiteKing)
        return true if input_board.content[0][0].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] && posn_selected == [2, 0] && input_board.content[0][1].nil? && input_board.content[0][2].nil? && input_board.content[0][3].nil?

        return true if input_board.content[0][7].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] && posn_selected == [6, 0] && input_board.content[0][5].nil? && input_board.content[0][6].nil?
      elsif piece_selected.is_a?(BlackKing)
        return true if input_board.content[7][0].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] && posn_selected == [2, 7] && input_board.content[7][1].nil? && input_board.content[7][2].nil? && input_board.content[7][3].nil?

        return true if input_board.content[7][7].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] && posn_selected == [6, 7] && input_board.content[7][5].nil? && input_board.content[7][6].nil?
      end
    end

  # Determines if move is a legal castling move
  def castling_moves(posn_selected, piece_selected, target_piece_selected, input_board)
    return false unless target_piece_selected.nil?

    if piece_selected.is_a?(WhiteKing) && input_board.content[0][0].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] && posn_selected == [2, 0] && input_board.content[0][1].nil? && input_board.content[0][2].nil? && input_board.content[0][3].nil?
      input_rook = input_board.content[0][0]
      input_board.content[0][0] = nil
      input_board.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]] = nil
      input_board.content[posn_selected[1]][posn_selected[0]] = piece_selected
      input_board.content[0][3] = input_rook
      input_rook.piece_posn = [3, 0]
      piece_selected.piece_posn = posn_selected

    elsif piece_selected.is_a?(WhiteKing) && input_board.content[0][7].is_a?(WhiteRook) && piece_selected.piece_posn == [4, 0] && posn_selected == [6, 0] && input_board.content[0][5].nil? && input_board.content[0][6].nil?
      input_rook = input_board.content[0][7]
      input_board.content[0][7] = nil
      input_board.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]] = nil
      input_board.content[posn_selected[1]][posn_selected[0]] = piece_selected
      input_board.content[0][5] = input_rook
      input_rook.piece_posn = [5, 0]
      piece_selected.piece_posn = posn_selected

    elsif piece_selected.is_a?(BlackKing) && input_board.content[7][0].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] && posn_selected == [2, 7] && input_board.content[7][1].nil? && input_board.content[7][2].nil? && input_board.content[7][3].nil?
      input_rook = input_board.content[7][0]
      input_board.content[7][0] = nil
      input_board.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]] = nil
      input_board.content[posn_selected[1]][posn_selected[0]] = piece_selected
      input_board.content[7][3] = input_rook
      input_rook.piece_posn = [3, 7]
      piece_selected.piece_posn = posn_selected

    elsif piece_selected.is_a?(BlackKing) && input_board.content[7][7].is_a?(BlackRook) && piece_selected.piece_posn == [4, 7] && posn_selected == [6, 7] && input_board.content[7][5].nil? && input_board.content[7][6].nil?
      input_rook = input_board.content[7][7]
      input_board.content[7][7] = nil
      input_board.content[piece_selected.piece_posn[1]][piece_selected.piece_posn[0]] = nil
      input_board.content[posn_selected[1]][posn_selected[0]] = piece_selected
      input_board.content[7][5] = input_rook
      input_rook.piece_posn = [5, 7]
      piece_selected.piece_posn = posn_selected

    end
  end

  # Main play loop
  def play
    @board.print_board
    until tie_game?
      piece_selected = nil
      target_piece_selected = nil
      posn_selected = [-1, -1]
      piece_posn = [-1, -1]
      until move_legal?(posn_selected, piece_selected, target_piece_selected, @board)
        piece_selected = nil
        until selection_own_piece?(piece_selected)
          piece_posn = acquire_piece_position
          piece_selected = select_piece(piece_posn)
        end
        posn_selected = select_posn
        target_piece_selected = select_piece(posn_selected)
      end
      move_piece(@board, piece_selected, posn_selected)
      unless target_piece_selected.nil?
        opponent_player_piece_array = @player_ordered_list[1].chess_pieces_array
        opponent_player_piece_array.delete(target_piece_selected)
      end
      @board.print_board
      break if player_won?

      switch_player
    end
    player_won? ? puts("#{@player_ordered_list[0].name} has won the game!") : puts('TIE!')
  end
end
