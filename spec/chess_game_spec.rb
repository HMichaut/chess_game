# frozen_string_literal: true

require_relative '../lib/chess_game'

describe ChessGame do
  subject(:new_game) { described_class.new }

  describe '#is_input_on_the_board?' do
    it 'Returns true for a input at [0, 0]' do
      solution = new_game.is_input_on_the_board?([0, 0])
      expect(solution).to be true
    end
    it 'Returns true for a input at [7, 7]' do
      solution = new_game.is_input_on_the_board?([7, 7])
      expect(solution).to be true
    end
    it 'Returns true for a input at [7, 0]' do
      solution = new_game.is_input_on_the_board?([7, 0])
      expect(solution).to be true
    end
    it 'Returns true for a input at [0, 7]' do
      solution = new_game.is_input_on_the_board?([0, 7])
      expect(solution).to be true
    end
    it 'Returns false for a input at [-1, 0]' do
      solution = new_game.is_input_on_the_board?([-1, 0])
      expect(solution).to be false
    end
    it 'Returns false for a input at [8, 7]' do
      solution = new_game.is_input_on_the_board?([8, 7])
      expect(solution).to be false
    end
    it 'Returns false for a input at [8, 0]' do
      solution = new_game.is_input_on_the_board?([8, 0])
      expect(solution).to be false
    end
    it 'Returns false for a input at [0, 8]' do
      solution = new_game.is_input_on_the_board?([0, 8])
      expect(solution).to be false
    end
  end

  describe '#move_piece' do
    it 'Move piece to specified point' do
      piece_checked = new_game.board.content[1][0]
      new_game.move_piece(new_game.board, piece_checked, [0, 2])
      solution = new_game.board.content[1][0].nil? && new_game.board.content[2][0] == piece_checked
      expect(solution).to be true
    end
  end

  describe '#selection_own_piece?' do
    it 'Return true for selecting own piece' do
      piece_checked = new_game.board.content[1][0]
      solution = new_game.selection_own_piece?(piece_checked)
      expect(solution).to be true
    end
    it 'Return false for selecting other player piece' do
      piece_checked = new_game.board.content[6][0]
      solution = new_game.selection_own_piece?(piece_checked)
      expect(solution).to be false
    end
  end

  describe '#create_legal_moves_array' do
    it 'Return correct array for a pawn without attacked piece' do
      piece_checked = WhitePawn.new([3, 3])
      solution = new_game.create_legal_moves_array(piece_checked, nil)
      expect(solution).to eql([[3, 4]])
    end
    it 'Return correct array for a pawn with attacked piece' do
      piece_checked = WhitePawn.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[4, 4], [2, 4]])
    end
    it 'Return correct array for a knight without attacked piece' do
      piece_checked = WhiteKnight.new([3, 3])
      solution = new_game.create_legal_moves_array(piece_checked, nil)
      expect(solution).to eql([[4, 5], [5, 4], [2, 1], [1, 2], [2, 5], [1, 4], [4, 1], [5, 2]])
    end
    it 'Return correct array for a knight with attacked piece' do
      piece_checked = WhiteKnight.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[4, 5], [5, 4], [2, 1], [1, 2], [2, 5], [1, 4], [4, 1], [5, 2]])
    end
    it 'Return correct array for a bishop without attacked piece' do
      piece_checked = WhiteBishop.new([3, 3])
      solution = new_game.create_legal_moves_array(piece_checked, nil)
      expect(solution).to eql([[4, 4], [5, 5], [6, 6], [7, 7],
                               [2, 4], [1, 5], [0, 6],
                               [4, 2], [5, 1], [6, 0],
                               [2, 2], [1, 1], [0, 0]])
    end
    it 'Return correct array for a bishop with attacked piece' do
      piece_checked = WhiteBishop.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[4, 4], [5, 5], [6, 6], [7, 7],
                               [2, 4], [1, 5], [0, 6],
                               [4, 2], [5, 1], [6, 0],
                               [2, 2], [1, 1], [0, 0]])
    end
    it 'Return correct array for a rook without attacked piece' do
      piece_checked = WhiteRook.new([3, 3])
      solution = new_game.create_legal_moves_array(piece_checked, nil)
      expect(solution).to eql([[3, 4], [3, 5], [3, 6], [3, 7],
                               [3, 2], [3, 1], [3, 0],
                               [4, 3], [5, 3], [6, 3], [7, 3],
                               [2, 3], [1, 3], [0, 3]])
    end
    it 'Return correct array for a queen with attacked piece' do
      piece_checked = WhiteQueen.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[3, 4], [3, 5], [3, 6], [3, 7],
                               [3, 2], [3, 1], [3, 0],
                               [4, 3], [5, 3], [6, 3], [7, 3],
                               [2, 3], [1, 3], [0, 3],
                               [4, 4], [5, 5], [6, 6], [7, 7],
                               [2, 4], [1, 5], [0, 6],
                               [4, 2], [5, 1], [6, 0],
                               [2, 2], [1, 1], [0, 0]])
    end
    it 'Return correct array for a queen with attacked piece' do
      piece_checked = WhiteQueen.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[3, 4], [3, 5], [3, 6], [3, 7],
                               [3, 2], [3, 1], [3, 0],
                               [4, 3], [5, 3], [6, 3], [7, 3],
                               [2, 3], [1, 3], [0, 3],
                               [4, 4], [5, 5], [6, 6], [7, 7],
                               [2, 4], [1, 5], [0, 6],
                               [4, 2], [5, 1], [6, 0],
                               [2, 2], [1, 1], [0, 0]])
    end
    it 'Return correct array for a king with attacked piece' do
      piece_checked = WhiteKing.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[3, 4], [4, 4], [4, 3], [4, 2], [3, 2], [2, 2], [2, 3], [2, 4]])
    end
    it 'Return correct array for a king with attacked piece' do
      piece_checked = WhiteKing.new([3, 3])
      piece_attacked = BlackPawn.new([4, 4])
      solution = new_game.create_legal_moves_array(piece_checked, piece_attacked)
      expect(solution).to eql([[3, 4], [4, 4], [4, 3], [4, 2], [3, 2], [2, 2], [2, 3], [2, 4]])
    end
  end

  describe '#obstruction' do
  end

end

# new_game.board.content = Array.new(8) { Array.new(8, nil) }
#       new_game.board.content[3][3] = WhitePawn.new([3, 3])
