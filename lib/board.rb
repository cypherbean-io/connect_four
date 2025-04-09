# frozen_string_literal: true

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(7) { Array.new(6) }
  end
end
