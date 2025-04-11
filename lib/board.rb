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

  # Need to refactor into smaller methods
  def display
    result = "| 0 | 1 | 2 | 3 | 4 | 5 | 6 |\n"
    result += "|---|---|---|---|---|---|---|\n"

    5.downto(0) do |row|
      result += '|'
      0.upto(6) do |col|
        piece = @grid[col][row]
        if piece.nil?
          result += '   |'
        else
          marker = piece == :red ? ' R ' : ' B '
          result += "#{marker}|"
        end
      end
      result += "\n"
    end

    result += "|---|---|---|---|---|---|---|\n"
    result
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
