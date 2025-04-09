# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#place_piece' do
    context 'when the column is not full' do
      it 'places a piece at the bottom of an empty column' do
        column = 3
        board.place_piece(column, :red)
        expect(board.grid[column][0]).to eq(piece)
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
end
