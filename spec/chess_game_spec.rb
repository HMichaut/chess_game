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

  describe '#obstruction?' do
    it 'Return false for an horizontal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [4, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [3, 4], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [4, 4], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [2, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [3, 2], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [2, 2], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      solution = new_game.obstruction?([0, 0], [2, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      solution = new_game.obstruction?([0, 0], [1, 2], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a knight move with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      new_game.board.content[0][1] = BlackPawn.new([1, 0])
      solution = new_game.obstruction?([0, 0], [2, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a knight move with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      new_game.board.content[1][0] = BlackPawn.new([0, 1])
      solution = new_game.obstruction?([0, 0], [1, 2], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [5, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [1, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][5] = BlackPawn.new([5, 3])
      solution = new_game.obstruction?([3, 3], [6, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.obstruction?([3, 3], [0, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][6] = BlackPawn.new([6, 3])
      solution = new_game.obstruction?([3, 3], [7, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][4] = WhitePawn.new([4, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.obstruction?([4, 3], [0, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return false for an vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [3, 5], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [3, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][3] = BlackPawn.new([3, 5])
      solution = new_game.obstruction?([3, 3], [3, 6], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.obstruction?([3, 3], [3, 0], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][3] = BlackPawn.new([3, 6])
      solution = new_game.obstruction?([3, 3], [3, 7], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][3] = WhitePawn.new([3, 4])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.obstruction?([3, 4], [3, 0], new_game.board)
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [5, 5], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.obstruction?([3, 3], [1, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][5] = BlackPawn.new([5, 5])
      solution = new_game.obstruction?([3, 3], [6, 6], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.obstruction?([3, 3], [0, 0], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      solution = new_game.obstruction?([3, 3], [7, 7], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][4] = WhitePawn.new([4, 4])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.obstruction?([4, 4], [0, 0], new_game.board)
      expect(solution).to be true
    end
  end

  describe '#move_one_square?' do
    it 'Return true for an horizontal move of one square' do
      solution = new_game.move_one_square?([3, 3], [4, 3])
      expect(solution).to be true
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.move_one_square?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.move_one_square?([3, 3], [4, 4])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.move_one_square?([3, 3], [2, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.move_one_square?([3, 3], [3, 2])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.move_one_square?([3, 3], [2, 2])
      expect(solution).to be true
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.move_one_square?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of two squares' do
      solution = new_game.move_one_square?([3, 3], [3, 5])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of two squares' do
      solution = new_game.move_one_square?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares' do
      solution = new_game.move_one_square?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares' do
      solution = new_game.move_one_square?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares' do
      solution = new_game.move_one_square?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#move_knight?' do
    it 'Return true for a knight move' do
      solution = new_game.move_knight?([0, 0], [2, 1])
      expect(solution).to be true
    end
    it 'Return true for a knight move' do
      solution = new_game.move_knight?([0, 0], [1, 2])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.move_knight?([0, 0], [1, 1])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.move_knight?([0, 0], [0, 1])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.move_knight?([0, 0], [1, 0])
      expect(solution).to be false
    end
    it 'Return false for a vertical move of two squares' do
      solution = new_game.move_knight?([0, 0], [0, 2])
      expect(solution).to be false
    end
    it 'Return false for a vertical move of one square' do
      solution = new_game.move_knight?([0, 0], [1, 0])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one quare' do
      solution = new_game.move_knight?([0, 0], [2, 2])
      expect(solution).to be false
    end
  end

  describe '#move_horizontal?' do
    it 'Return false for a knight move' do
      solution = new_game.move_horizontal?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.move_horizontal?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [4, 3])
      expect(solution).to be true
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.move_horizontal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [4, 4])
      expect(solution).to be false
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [2, 3])
      expect(solution).to be true
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.move_horizontal?([3, 3], [3, 2])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [2, 2])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of two squares' do
      solution = new_game.move_horizontal?([3, 3], [5, 3])
      expect(solution).to be true
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.move_horizontal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [1, 3])
      expect(solution).to be true
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.move_horizontal?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.move_horizontal?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#horizontal_obstruction?' do
    it 'Return false for an horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.horizontal_obstruction?([3, 3], [5, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.horizontal_obstruction?([3, 3], [1, 3], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][5] = BlackPawn.new([5, 3])
      solution = new_game.horizontal_obstruction?([3, 3], [6, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.horizontal_obstruction?([3, 3], [0, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][6] = BlackPawn.new([6, 3])
      solution = new_game.horizontal_obstruction?([3, 3], [7, 3], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][4] = WhitePawn.new([4, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.horizontal_obstruction?([4, 3], [0, 3], new_game.board)
      expect(solution).to be true
    end
  end

  describe '#move_vertical?' do
    it 'Return false for a knight move' do
      solution = new_game.move_vertical?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.move_vertical?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.move_vertical?([3, 3], [4, 3])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.move_vertical?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.move_vertical?([3, 3], [4, 4])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.move_vertical?([3, 3], [2, 3])
      expect(solution).to be false
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.move_vertical?([3, 3], [3, 2])
      expect(solution).to be true
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.move_vertical?([3, 3], [2, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.move_vertical?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.move_vertical?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.move_vertical?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.move_vertical?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.move_vertical?([3, 3], [3, 1])
      expect(solution).to be true
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.move_vertical?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#vertical_obstruction?' do
    it 'Return false for an vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.vertical_obstruction?([3, 3], [3, 5], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.vertical_obstruction?([3, 3], [3, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][3] = BlackPawn.new([3, 5])
      solution = new_game.vertical_obstruction?([3, 3], [3, 6], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.vertical_obstruction?([3, 3], [3, 0], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][3] = BlackPawn.new([3, 6])
      solution = new_game.vertical_obstruction?([3, 3], [3, 7], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][3] = WhitePawn.new([3, 4])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.vertical_obstruction?([3, 4], [3, 0], new_game.board)
      expect(solution).to be true
    end
  end

  describe '#move_diagonal?' do
    it 'Return false for a knight move' do
      solution = new_game.move_diagonal?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.move_diagonal?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [4, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.move_diagonal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [4, 4])
      expect(solution).to be true
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [2, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.move_diagonal?([3, 3], [3, 2])
      expect(solution).to be false
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [2, 2])
      expect(solution).to be true
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.move_diagonal?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.move_diagonal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [5, 5])
      expect(solution).to be true
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.move_diagonal?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.move_diagonal?([3, 3], [1, 1])
      expect(solution).to be true
    end
  end

  describe '#diagonal_obstruction?' do
    it 'Return false for an diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.diagonal_obstruction?([3, 3], [5, 5], new_game.board)
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.diagonal_obstruction?([3, 3], [1, 1], new_game.board)
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][5] = BlackPawn.new([5, 5])
      solution = new_game.diagonal_obstruction?([3, 3], [6, 6], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.diagonal_obstruction?([3, 3], [0, 0], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      solution = new_game.diagonal_obstruction?([3, 3], [7, 7], new_game.board)
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][4] = WhitePawn.new([4, 4])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.diagonal_obstruction?([4, 4], [0, 0], new_game.board)
      expect(solution).to be true
    end
  end

  describe '#switch_player' do
    xit 'TBC' do
    end
  end

  describe '#tie_game?' do
    xit 'TBC' do
    end
  end

  describe '#no_move_possible?' do
    xit 'TBC' do
    end
  end

  describe '#player_won?' do
    xit 'TBC' do
    end
  end

  describe '#king_cannot_be_saved?' do
    xit 'TBC' do
    end
  end

  describe '#muster_all_pieces_for_player' do
    xit 'TBC' do
    end
  end

  describe '#inform_which_piece_create_check' do
    xit 'TBC' do
    end
  end
  
  describe '#acquire_piece_position' do
    xit 'TBC' do
    end
  end
end
