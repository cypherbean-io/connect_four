# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#place_piece' do
    context 'when the column is not full' do
      it 'places a piece at the bottom of an empty column' do
        column = 3
        board.place_piece(column, :red)
        expect(board.grid[column][0]).to eq(:red)
      end

      it 'stacks a piece on top of existing pieces' do
        column = 3
        board.place_piece(column, :red)
        board.place_piece(column, :black)
        expect(board.grid[column][1]).to eq(:black)
      end
    end

    context 'when the column is full' do
      it 'returns false' do
        column = 3
        6.times { board.place_piece(column, :red) }
        expect(board.place_piece(column, :black)).to eq(false)
      end
    end

    context 'when the column is invalid' do
      it 'returns false for negative column' do
        expect(board.place_piece(-1, :red)).to eq(false)
      end

      it 'returns false for column greater than 6' do
        expect(board.place_piece(7, :red)).to eq(false)
      end
    end
  end

  describe '#display' do
    it 'displays the board with placed pieces' do
      board.place_piece(0, :red)
      board.place_piece(1, :black)
      board.place_piece(1, :red)

      expected_display = <<~BOARD
        | 0 | 1 | 2 | 3 | 4 | 5 | 6 |
        |---|---|---|---|---|---|---|
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   |   |   |   |   |   |   |
        |   | R |   |   |   |   |   |
        | R | B |   |   |   |   |   |
        |---|---|---|---|---|---|---|
      BOARD
      expect(board.display).to eq(expected_display)
    end
  end

  describe '#winning_move?' do
    context 'when there are 4 in a row horizontally' do
      it 'returns true' do
        piece = :red
        board.place_piece(0, piece)
        board.place_piece(1, piece)
        board.place_piece(2, piece)
        board.place_piece(3, piece)
        expect(board.winning_move?(3, piece)).to be true
      end
    end

    context 'when there are 4 in a row vertically' do
      it 'returns true' do
        column = 3
        piece = :red
        4.times { board.place_piece(column, piece) }
        expect(board.winning_move?(column, piece)).to be true
      end
    end

    context 'when there are 4 in a row diagonally (upward)' do
      it 'returns true' do
        piece = :red
        opposite = :black

        # Set up the board:
        # . . . . . . .
        # . . . . . . .
        # . . . R . . .
        # . . R R . . .
        # . R B B . . .
        # R B B B . . .

        board.place_piece(0, piece)
        board.place_piece(1, opposite)
        board.place_piece(1, piece)
        board.place_piece(2, opposite)
        board.place_piece(2, opposite)
        board.place_piece(2, piece)
        board.place_piece(3, opposite)
        board.place_piece(3, opposite)
        board.place_piece(3, piece)
        board.place_piece(3, piece)

        expect(board.winning_move?(3, piece)).to be true
      end
    end

    context 'when there are 4 in a row diagonally (downward)' do
      it 'returns true' do
        piece = :red
        opposite = :black

        # Set up the board:
        # . . . . . . .
        # . . . . . . .
        # R . . . . . .
        # R R . . . . .
        # B R R . . . .
        # B B B R . . .

        board.place_piece(0, opposite)
        board.place_piece(0, opposite)
        board.place_piece(0, piece)
        board.place_piece(0, piece)
        board.place_piece(1, opposite)
        board.place_piece(1, piece)
        board.place_piece(1, piece)
        board.place_piece(2, opposite)
        board.place_piece(2, piece)
        board.place_piece(3, piece)

        expect(board.winning_move?(3, piece)).to be true
      end
    end

    context 'when there is no win' do
      it 'returns false' do
        piece = :red

        board.place_piece(0, piece)
        board.place_piece(1, piece)
        board.place_piece(2, piece)
        board.place_piece(4, piece)

        expect(board.winning_move?(4, piece)).to be false
      end
    end
  end
end
