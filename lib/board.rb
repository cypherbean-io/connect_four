# frozen_string_literal: true

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(7) { Array.new(6) }
  end

  def place_piece(column, piece)
    return false unless valid_column?(column)

    row = next_available_row(column)
    return false if row.nil?

    @grid[column][row] = piece
    true
  end

  private

  def valid_column?(column)
    column.between?(0, 6)
  end

  def next_available_row(column)
    @grid[column].each_with_index do |cell, row|
      return row if cell.nil?
    end
    nil
  end
end
