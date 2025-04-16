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

  def winning_move?(column, piece)
    return false unless valid_column?(column)

    # For checking the winning move, we need to check all positions where this piece exists
    # rather than just finding the first one
    rows_with_piece = []
    @grid[column].each_with_index do |cell, row|
      rows_with_piece << row if cell == piece
    end

    return false if rows_with_piece.empty?

    # Check each position where this piece exists in the column
    rows_with_piece.each do |row|
      # Check horizontal
      return true if check_horizontal(column, row, piece)

      # Check vertical
      return true if check_vertical(column, row, piece)

      # Check diagonal (rising)
      return true if check_diagonal_rising(column, row, piece)

      # Check diagonal (falling)
      return true if check_diagonal_falling(column, row, piece)
    end

    false
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

  def check_horizontal(column, row, piece)
    # Check to the left
    left_count = 0
    current_col = column - 1
    while current_col >= 0 && @grid[current_col][row] == piece
      left_count += 1
      current_col -= 1
    end

    # Check to the right
    right_count = 0
    current_col = column + 1
    while current_col < 7 && @grid[current_col][row] == piece
      right_count += 1
      current_col += 1
    end

    # The original piece plus the consecutive ones to the left and right
    left_count + 1 + right_count >= 4
  end

  def check_vertical(column, row, piece)
    # Only need to check below (pieces can't be floating)
    down_count = 0
    current_row = row - 1
    while current_row >= 0 && @grid[column][current_row] == piece
      down_count += 1
      current_row -= 1
    end

    down_count + 1 >= 4
  end

  def check_diagonal_rising(column, row, piece)
    # Check down-left
    down_left_count = 0
    c = column - 1
    r = row - 1
    while c >= 0 && r >= 0 && @grid[c][r] == piece
      down_left_count += 1
      c -= 1
      r -= 1
    end

    # Check up-right
    up_right_count = 0
    c = column + 1
    r = row + 1
    while c < 7 && r < 6 && @grid[c][r] == piece
      up_right_count += 1
      c += 1
      r += 1
    end

    down_left_count + 1 + up_right_count >= 4
  end

  def check_diagonal_falling(column, row, piece)
    # Check down-right
    down_right_count = 0
    c = column + 1
    r = row - 1
    while c < 7 && r >= 0 && @grid[c][r] == piece
      down_right_count += 1
      c += 1
      r -= 1
    end

    # Check up-left
    up_left_count = 0
    c = column - 1
    r = row + 1
    while c >= 0 && r < 6 && @grid[c][r] == piece
      up_left_count += 1
      c -= 1
      r += 1
    end

    down_right_count + 1 + up_left_count >= 4
  end
end
