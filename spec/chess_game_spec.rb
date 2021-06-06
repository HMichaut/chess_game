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
    it 'complex diagonal movement' do
      new_game.move_piece(new_game.board, new_game.board.content[1][3], [3, 2]) if new_game.move_legal?([3, 2], new_game.board.content[1][3], nil, new_game.board)
      new_game.move_piece(new_game.board, new_game.board.content[6][0], [0, 5]) if new_game.move_legal?([0, 5], new_game.board.content[6][0], nil, new_game.board)
      piece_checked = new_game.board.content[0][2]
      new_game.move_piece(new_game.board, piece_checked, [7, 5]) if new_game.move_legal?([7, 5], piece_checked, nil, new_game.board)
      new_game.move_piece(new_game.board, piece_checked, [0, 0]) if new_game.move_legal?([0, 0], piece_checked, nil, new_game.board)
      solution = new_game.board.content[0][2].nil? && new_game.board.content[5][7] == piece_checked
      expect(solution).to be true
    end
    it 'second complex diagonal movement' do
      new_game.move_piece(new_game.board, new_game.board.content[1][3], [3, 2]) if new_game.move_legal?([3, 2], new_game.board.content[1][3], nil, new_game.board)
      new_game.move_piece(new_game.board, new_game.board.content[6][3], [3, 5]) if new_game.move_legal?([3, 5], new_game.board.content[6][3], nil, new_game.board)
      piece_checked = new_game.board.content[0][2]
      new_game.move_piece(new_game.board, piece_checked, [7, 5]) if new_game.move_legal?([7, 5], piece_checked, nil, new_game.board)
      second_piece_checked = new_game.board.content[7][2]
      new_game.move_piece(new_game.board, second_piece_checked, [6, 3]) if new_game.move_legal?([6, 3], second_piece_checked, nil, new_game.board)
      solution = new_game.board.content[0][2].nil? && new_game.board.content[5][7] == piece_checked
      expect(solution).to be true
    end
    it 'third complex diagonal movement' do
      new_game.move_piece(new_game.board, new_game.board.content[1][1], [1, 2]) if new_game.move_legal?([1, 2], new_game.board.content[1][1], nil, new_game.board)
      new_game.move_piece(new_game.board, new_game.board.content[6][0], [0, 5]) if new_game.move_legal?([0, 5], new_game.board.content[6][0], nil, new_game.board)
      piece_checked = new_game.board.content[0][2]
      new_game.move_piece(new_game.board, piece_checked, [0, 2]) if new_game.move_legal?([0, 2], piece_checked, nil, new_game.board)
      solution = new_game.board.content[0][2].nil? && new_game.board.content[2][0] == piece_checked
      expect(solution).to be true
    end
    it 'fourth complex diagonal movement' do
      new_game.move_piece(new_game.board, new_game.board.content[1][3], [3, 2]) if new_game.move_legal?([3, 2], new_game.board.content[1][3], nil, new_game.board)
      new_game.move_piece(new_game.board, new_game.board.content[6][1], [1, 5]) if new_game.move_legal?([1, 5], new_game.board.content[6][1], nil, new_game.board)
      piece_checked = new_game.board.content[0][2]
      new_game.move_piece(new_game.board, piece_checked, [7, 5]) if new_game.move_legal?([7, 5], piece_checked, nil, new_game.board)
      second_piece_checked = new_game.board.content[7][2]
      new_game.move_piece(new_game.board, second_piece_checked, [0, 5]) if new_game.move_legal?([0, 5], second_piece_checked, nil, new_game.board)
      solution = new_game.board.content[0][2].nil? && new_game.board.content[5][7] == piece_checked
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
      expect(solution).to eql([[3, 4], [3, 5]])
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
      solution = new_game.board.obstruction?([3, 3], [4, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [4, 4])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [2, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [3, 2])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [2, 2])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      solution = new_game.board.obstruction?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      solution = new_game.board.obstruction?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for a knight move with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      new_game.board.content[0][1] = BlackPawn.new([1, 0])
      solution = new_game.board.obstruction?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][0] = WhitePawn.new([0, 0])
      new_game.board.content[1][0] = BlackPawn.new([0, 1])
      solution = new_game.board.obstruction?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][5] = BlackPawn.new([5, 3])
      solution = new_game.board.obstruction?([3, 3], [6, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.board.obstruction?([3, 3], [0, 3])
      expect(solution).to be true
    end
    it 'Return true for an horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][6] = BlackPawn.new([6, 3])
      solution = new_game.board.obstruction?([3, 3], [7, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][4] = WhitePawn.new([4, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.board.obstruction?([4, 3], [0, 3])
      expect(solution).to be true
    end
    it 'Return false for an vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [3, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][3] = BlackPawn.new([3, 5])
      solution = new_game.board.obstruction?([3, 3], [3, 6])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.board.obstruction?([3, 3], [3, 0])
      expect(solution).to be true
    end
    it 'Return true for an vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][3] = BlackPawn.new([3, 6])
      solution = new_game.board.obstruction?([3, 3], [3, 7])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][3] = WhitePawn.new([3, 4])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.board.obstruction?([3, 4], [3, 0])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.obstruction?([3, 3], [1, 1])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][5] = BlackPawn.new([5, 5])
      solution = new_game.board.obstruction?([3, 3], [6, 6])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.board.obstruction?([3, 3], [0, 0])
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      solution = new_game.board.obstruction?([3, 3], [7, 7])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][4] = WhitePawn.new([4, 4])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.board.obstruction?([4, 4], [0, 0])
      expect(solution).to be true
    end
  end

  describe '#move_one_square?' do
    it 'Return true for an horizontal move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [4, 3])
      expect(solution).to be true
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [4, 4])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [2, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [3, 2])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.board.move_one_square?([3, 3], [2, 2])
      expect(solution).to be true
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [3, 5])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares' do
      solution = new_game.board.move_one_square?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#move_knight?' do
    it 'Return true for a knight move' do
      solution = new_game.board.move_knight?([0, 0], [2, 1])
      expect(solution).to be true
    end
    it 'Return true for a knight move' do
      solution = new_game.board.move_knight?([0, 0], [1, 2])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.board.move_knight?([0, 0], [1, 1])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.board.move_knight?([0, 0], [0, 1])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.board.move_knight?([0, 0], [1, 0])
      expect(solution).to be false
    end
    it 'Return false for a vertical move of two squares' do
      solution = new_game.board.move_knight?([0, 0], [0, 2])
      expect(solution).to be false
    end
    it 'Return false for a vertical move of one square' do
      solution = new_game.board.move_knight?([0, 0], [1, 0])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one quare' do
      solution = new_game.board.move_knight?([0, 0], [2, 2])
      expect(solution).to be false
    end
  end

  describe '#move_horizontal?' do
    it 'Return false for a knight move' do
      solution = new_game.board.move_horizontal?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.board.move_horizontal?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [4, 3])
      expect(solution).to be true
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [4, 4])
      expect(solution).to be false
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [2, 3])
      expect(solution).to be true
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [3, 2])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [2, 2])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of two squares' do
      solution = new_game.board.move_horizontal?([3, 3], [5, 3])
      expect(solution).to be true
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return true for a negative horizontal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [1, 3])
      expect(solution).to be true
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.board.move_horizontal?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#horizontal_obstruction?' do
    it 'Return false for an horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.horizontal_obstruction?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.horizontal_obstruction?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return true for an horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][5] = BlackPawn.new([5, 3])
      solution = new_game.board.horizontal_obstruction?([3, 3], [6, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.board.horizontal_obstruction?([3, 3], [0, 3])
      expect(solution).to be true
    end
    it 'Return true for an horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[3][6] = BlackPawn.new([6, 3])
      solution = new_game.board.horizontal_obstruction?([3, 3], [7, 3])
      expect(solution).to be true
    end
    it 'Return true for a negative horizontal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][4] = WhitePawn.new([4, 3])
      new_game.board.content[3][1] = BlackPawn.new([1, 3])
      solution = new_game.board.horizontal_obstruction?([4, 3], [0, 3])
      expect(solution).to be true
    end
  end

  describe '#move_vertical?' do
    it 'Return false for a knight move' do
      solution = new_game.board.move_vertical?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.board.move_vertical?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [4, 3])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [4, 4])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [2, 3])
      expect(solution).to be false
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [3, 2])
      expect(solution).to be true
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [2, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.board.move_vertical?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [3, 4])
      expect(solution).to be true
    end
    it 'Return false for an diagonal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return true for a negative vertical move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [3, 1])
      expect(solution).to be true
    end
    it 'Return false for a negative diagonal move of one square' do
      solution = new_game.board.move_vertical?([3, 3], [1, 1])
      expect(solution).to be false
    end
  end

  describe '#vertical_obstruction?' do
    it 'Return false for an vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.vertical_obstruction?([3, 3], [3, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.vertical_obstruction?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return true for an vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][3] = BlackPawn.new([3, 5])
      solution = new_game.board.vertical_obstruction?([3, 3], [3, 6])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.board.vertical_obstruction?([3, 3], [3, 0])
      expect(solution).to be true
    end
    it 'Return true for an vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][3] = BlackPawn.new([3, 6])
      solution = new_game.board.vertical_obstruction?([3, 3], [3, 7])
      expect(solution).to be true
    end
    it 'Return true for a negative vertical move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][3] = WhitePawn.new([3, 4])
      new_game.board.content[1][3] = BlackPawn.new([3, 1])
      solution = new_game.board.vertical_obstruction?([3, 4], [3, 0])
      expect(solution).to be true
    end
  end

  describe '#move_diagonal?' do
    it 'Return false for a knight move' do
      solution = new_game.board.move_diagonal?([0, 0], [2, 1])
      expect(solution).to be false
    end
    it 'Return false for a knight move' do
      solution = new_game.board.move_diagonal?([0, 0], [1, 2])
      expect(solution).to be false
    end
    it 'Return false for an horizontal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [4, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [4, 4])
      expect(solution).to be true
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [2, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [3, 2])
      expect(solution).to be false
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [2, 2])
      expect(solution).to be true
    end
    it 'Return false for an horizontal move of two squares' do
      solution = new_game.board.move_diagonal?([3, 3], [5, 3])
      expect(solution).to be false
    end
    it 'Return false for an vertical move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [3, 4])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [5, 5])
      expect(solution).to be true
    end
    it 'Return false for a negative horizontal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [1, 3])
      expect(solution).to be false
    end
    it 'Return false for a negative vertical move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [3, 1])
      expect(solution).to be false
    end
    it 'Return true for a negative diagonal move of one square' do
      solution = new_game.board.move_diagonal?([3, 3], [1, 1])
      expect(solution).to be true
    end
  end

  describe '#diagonal_obstruction?' do
    it 'Return false for an diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.diagonal_obstruction?([3, 3], [5, 5])
      expect(solution).to be false
    end
    it 'Return false for a negative diagonal move of two squares without obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      solution = new_game.board.diagonal_obstruction?([3, 3], [1, 1])
      expect(solution).to be false
    end
    it 'Return true for an diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[5][5] = BlackPawn.new([5, 5])
      solution = new_game.board.diagonal_obstruction?([3, 3], [6, 6])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of three squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.board.diagonal_obstruction?([3, 3], [0, 0])
      expect(solution).to be true
    end
    it 'Return true for an diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[3][3] = WhitePawn.new([3, 3])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      solution = new_game.board.diagonal_obstruction?([3, 3], [7, 7])
      expect(solution).to be true
    end
    it 'Return true for a negative diagonal move of four squares with obstruction' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[4][4] = WhitePawn.new([4, 4])
      new_game.board.content[1][1] = BlackPawn.new([1, 1])
      solution = new_game.board.diagonal_obstruction?([4, 4], [0, 0])
      expect(solution).to be true
    end
  end

  describe '#switch_player' do
    it 'switch from player 1 to player 2' do
      new_game.switch_player
      solution = new_game.player_ordered_list[0].color
      expect(solution).to eq('black')
    end
    it 'switch from player 1 to player 2 then back to player 1' do
      new_game.switch_player
      new_game.switch_player
      solution = new_game.player_ordered_list[0].color
      expect(solution).to eq('white')
    end
  end

  describe '#tie_game?' do
    it 'Return true for a simple tie game situation' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.tie_game?
      expect(solution).to be true
    end
    it 'Return true for a complex tie game situation' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[7][0] = WhiteKing.new([0, 7])
      new_game.board.content[7][6] = WhiteQueen.new([6, 7])
      new_game.board.content[7][7] = WhiteRook.new([7, 7])
      new_game.board.content[5][2] = WhiteKnight.new([2, 5])
      new_game.board.content[5][7] = BlackBishop.new([7, 5])
      new_game.board.content[4][0] = WhitePawn.new([0, 4])
      new_game.board.content[6][2] = BlackPawn.new([2, 6])
      new_game.board.content[5][0] = BlackPawn.new([0, 5])
      new_game.board.content[1][0] = WhiteRook.new([0, 1])
      new_game.board.content[0][7] = BlackKing.new([7, 0])
      solution = new_game.tie_game?
      expect(solution).to be true
    end
    it 'Return false for a tie game situation that can be solved by moving the king' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[3][1] = WhiteQueen.new([1, 3])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.tie_game?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by moving another piece' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      new_game.board.content[4][4] = BlackPawn.new([4, 4])
      solution = new_game.tie_game?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by attacking with the king' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[1][1] = WhiteRook.new([1, 1])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.tie_game?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by attacking with another piece' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      new_game.board.content[3][2] = BlackPawn.new([2, 3])
      solution = new_game.tie_game?
      expect(solution).to be false
    end
    it 'Return false for check situations' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[2][1] = WhiteRook.new([3, 0])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      new_game.board.content[3][2] = BlackPawn.new([2, 3])
      solution = new_game.tie_game?
      expect(solution).to be false
    end
  end

  describe '#no_move_possible?' do
    it 'Return true for a simple tie game situation' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.no_move_possible?
      expect(solution).to be true
    end
    it 'Return true for a complex tie game situation' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[7][0] = WhiteKing.new([0, 7])
      new_game.board.content[7][6] = WhiteQueen.new([6, 7])
      new_game.board.content[7][7] = WhiteRook.new([7, 7])
      new_game.board.content[5][2] = WhiteKnight.new([2, 5])
      new_game.board.content[5][7] = BlackBishop.new([7, 5])
      new_game.board.content[4][0] = WhitePawn.new([0, 4])
      new_game.board.content[6][2] = BlackPawn.new([2, 6])
      new_game.board.content[5][0] = BlackPawn.new([0, 5])
      new_game.board.content[1][0] = WhiteRook.new([0, 1])
      new_game.board.content[0][7] = BlackKing.new([7, 0])
      solution = new_game.no_move_possible?
      expect(solution).to be true
    end
    it 'Return false for a tie game situation that can be solved by moving the king' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[3][1] = WhiteQueen.new([1, 3])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.no_move_possible?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by moving another piece' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      new_game.board.content[4][4] = BlackPawn.new([4, 4])
      solution = new_game.no_move_possible?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by attacking with the king' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[1][1] = WhiteRook.new([1, 1])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      solution = new_game.no_move_possible?
      expect(solution).to be false
    end
    it 'Return false for a tie game situation that can be solved by attacking with another piece' do
      new_game.switch_player
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][4] = WhiteKing.new([4, 0])
      new_game.board.content[2][1] = WhiteQueen.new([1, 2])
      new_game.board.content[0][0] = BlackKing.new([0, 0])
      new_game.board.content[3][2] = BlackPawn.new([2, 3])
      solution = new_game.no_move_possible?
      expect(solution).to be false
    end
  end

  describe '#player_won?' do
    it 'Return false for the step before Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      new_game.board.content[2][4] = WhiteRook.new([4, 2])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackKing.new([7, 6])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      new_game.board.content[2][7] = WhiteRook.new([7, 2])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackKing.new([7, 6])
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Return false for the step before Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][5] = WhiteKing.new([5, 5])
      new_game.board.content[6][6] = WhitePawn.new([6, 6])
      new_game.board.content[1][7] = WhiteRook.new([7, 1])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][5] = WhiteKing.new([5, 5])
      new_game.board.content[6][6] = WhitePawn.new([6, 6])
      new_game.board.content[7][7] = WhiteRook.new([7, 7])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Return false for the step before Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      new_game.board.content[6][1] = WhiteRook.new([1, 6])
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      new_game.board.content[6][7] = WhiteRook.new([7, 6])
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Return false for the step before Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackPawn.new([7, 6])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      new_game.board.content[0][3] = WhiteRook.new([3, 0])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackPawn.new([7, 6])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      new_game.board.content[7][3] = WhiteRook.new([3, 7])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Return false for the step before Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteQueen.new([5, 5])
      new_game.board.content[2][5] = WhiteBishop.new([5, 2])
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteQueen.new([5, 5])
      new_game.board.content[5][2] = WhiteBishop.new([2, 5])
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.player_won?
      expect(solution).to be true
    end
    it 'Return false for the step before Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      new_game.board.content[2][3] = WhiteBishop.new([3, 2])
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.player_won?
      expect(solution).to be false
    end
    it 'Return true for the Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      new_game.board.content[6][7] = WhiteBishop.new([7, 6])
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.player_won?
      expect(solution).to be true
    end
  end

  describe '#king_cannot_be_saved?' do
    it 'Return false for an incorrect Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      attacking_piece = WhiteRook.new([7, 2])
      new_game.board.content[2][7] = attacking_piece
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[5][7] = BlackKing.new([7, 5])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      attacking_piece = WhiteRook.new([7, 2])
      new_game.board.content[2][7] = attacking_piece
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackKing.new([7, 6])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
    it 'Return false for an incorrect Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][4] = WhiteKing.new([4, 5])
      new_game.board.content[6][5] = WhitePawn.new([5, 6])
      attacking_piece = WhiteRook.new([7, 7])
      new_game.board.content[7][7] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][5] = WhiteKing.new([5, 5])
      new_game.board.content[6][6] = WhitePawn.new([6, 6])
      attacking_piece = WhiteRook.new([7, 7])
      new_game.board.content[7][7] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
    it 'Return false for an incorrect Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      attacking_piece = WhiteRook.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      attacking_piece = WhiteRook.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      new_game.board.content[1][1] = BlackRook.new([1, 1])
      new_game.board.content[1][2] = WhitePawn.new([2, 1])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
    it 'Return false for an incorrect Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[5][7] = BlackPawn.new([7, 5])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      attacking_piece = WhiteRook.new([3, 7])
      new_game.board.content[7][3] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackPawn.new([7, 6])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      attacking_piece = WhiteRook.new([3, 7])
      new_game.board.content[7][3] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
    it 'Return false for an incorrect Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[4][6] = WhiteQueen.new([6, 4])
      attacking_piece = WhiteBishop.new([2, 5])
      new_game.board.content[5][2] = attacking_piece
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteQueen.new([5, 5])
      attacking_piece = WhiteBishop.new([2, 5])
      new_game.board.content[5][2] = attacking_piece
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
    it 'Return false for an incorrect Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      attacking_piece = WhiteBishop.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be false
    end
    it 'Return true for the Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      attacking_piece = WhiteBishop.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.king_cannot_be_saved?(attacking_piece)
      expect(solution).to be true
    end
  end

  describe '#muster_all_pieces_for_player' do
    it 'Return one white piece' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      white_piece = WhiteKing.new([6, 0])
      black_piece = BlackKing.new([6, 7])
      new_game.board.content[0][6] = white_piece
      new_game.board.content[7][6] = black_piece
      input_player = new_game.player_ordered_list[0]
      input_board = new_game.board
      solution = input_player.muster_all_pieces_for_player(input_board)
      expect(solution).to eql([white_piece])
    end
    it 'Return one black piece' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      white_piece = WhiteKing.new([6, 0])
      black_piece = BlackKing.new([6, 7])
      new_game.board.content[0][6] = white_piece
      new_game.board.content[7][6] = black_piece
      input_player = new_game.player_ordered_list[1]
      input_board = new_game.board
      solution = input_player.muster_all_pieces_for_player(input_board)
      expect(solution).to eql([black_piece])
    end
    it 'Return three white pieces' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      first_white_piece = WhiteKing.new([6, 0])
      second_white_piece = WhiteKing.new([6, 1])
      third_white_piece = WhiteKing.new([6, 2])
      black_piece = BlackKing.new([6, 7])
      new_game.board.content[0][6] = first_white_piece
      new_game.board.content[1][6] = second_white_piece
      new_game.board.content[2][6] = third_white_piece
      new_game.board.content[7][6] = black_piece
      input_player = new_game.player_ordered_list[0]
      input_board = new_game.board
      solution = input_player.muster_all_pieces_for_player(input_board)
      expect(solution).to eql([first_white_piece, second_white_piece, third_white_piece])
    end
    it 'Return three black pieces' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      first_black_piece = BlackKing.new([6, 0])
      second_black_piece = BlackKing.new([6, 1])
      third_black_piece = BlackKing.new([6, 2])
      white_piece = WhiteKing.new([6, 7])
      new_game.board.content[0][6] = first_black_piece
      new_game.board.content[1][6] = second_black_piece
      new_game.board.content[2][6] = third_black_piece
      new_game.board.content[7][6] = white_piece
      input_player = new_game.player_ordered_list[1]
      input_board = new_game.board
      solution = input_player.muster_all_pieces_for_player(input_board)
      expect(solution).to eql([first_black_piece, second_black_piece, third_black_piece])
    end
  end

  describe '#inform_which_piece_create_check' do
    it 'Return nil for the step before Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      new_game.board.content[2][4] = WhiteRook.new([4, 2])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackKing.new([7, 6])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Anastasia mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][4] = WhiteKnight.new([4, 6])
      attacking_piece = WhiteRook.new([7, 2])
      new_game.board.content[2][7] = attacking_piece
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackKing.new([7, 6])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
    it 'Return nil for the step before Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][5] = WhiteKing.new([5, 5])
      new_game.board.content[6][6] = WhitePawn.new([6, 6])
      new_game.board.content[1][7] = WhiteRook.new([7, 1])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Andersen mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[5][5] = WhiteKing.new([5, 5])
      new_game.board.content[6][6] = WhitePawn.new([6, 6])
      attacking_piece = WhiteRook.new([7, 7])
      new_game.board.content[7][7] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
    it 'Return nil for the step before Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      new_game.board.content[6][1] = WhiteRook.new([1, 6])
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Arabian mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteKnight.new([5, 5])
      attacking_piece = WhiteRook.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[7][7] = BlackKing.new([7, 7])
      new_game.board.content[1][1] = BlackRook.new([1, 1])
      new_game.board.content[1][2] = WhitePawn.new([2, 1])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
    it 'Return nil for the step before Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackPawn.new([7, 6])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      new_game.board.content[0][3] = WhiteRook.new([3, 0])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Back Rank mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[6][5] = BlackPawn.new([5, 6])
      new_game.board.content[6][6] = BlackPawn.new([6, 6])
      new_game.board.content[6][7] = BlackPawn.new([7, 6])
      new_game.board.content[1][5] = WhitePawn.new([5, 1])
      new_game.board.content[1][6] = WhitePawn.new([6, 1])
      new_game.board.content[1][7] = WhitePawn.new([7, 1])
      attacking_piece = WhiteRook.new([3, 7])
      new_game.board.content[7][3] = attacking_piece
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
    it 'Return nil for the step before Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteQueen.new([5, 5])
      new_game.board.content[2][5] = WhiteBishop.new([5, 2])
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Balestra mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[5][5] = WhiteQueen.new([5, 5])
      attacking_piece = WhiteBishop.new([2, 5])
      new_game.board.content[5][2] = attacking_piece
      new_game.board.content[7][4] = BlackKing.new([4, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
    it 'Return nil for the step before Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      new_game.board.content[2][3] = WhiteBishop.new([3, 2])
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(nil)
    end
    it 'Return true for the Blackburne mate situation' do
      new_game.board.content = Array.new(8) { Array.new(8, nil) }
      new_game.board.content[0][6] = WhiteKing.new([6, 0])
      new_game.board.content[1][1] = WhiteBishop.new([1, 1])
      attacking_piece = WhiteBishop.new([7, 6])
      new_game.board.content[6][7] = attacking_piece
      new_game.board.content[4][6] = WhiteKnight.new([6, 4])
      new_game.board.content[7][6] = BlackKing.new([6, 7])
      new_game.board.content[7][5] = BlackRook.new([5, 7])
      solution = new_game.inform_which_piece_create_check(new_game.board, new_game.player_ordered_list[0], new_game.player_ordered_list[1])
      expect(solution).to eql(attacking_piece)
    end
  end
end
