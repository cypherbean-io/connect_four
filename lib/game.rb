# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :player1, :player2, :current_player, :last_move_column

  def initialize
    @board = Board.new
    @player1 = Player.new('Player 1', :red)
    @player2 = Player.new('Player 2', :black)
    @current_player = @player1
    @last_move_column = nil
    @game_over = false
  end

  def play
    puts 'Welcome to Connect Four!'

    until game_over?
      puts @board.display
      take_turn
      if game_over?
        puts @board.display
        announce_winner
      else
        switch_player
      end
    end
  end

  def take_turn
    puts "#{@current_player.name}'s turn (#{@current_player.piece == :red ? 'R' : 'B'}):"
    column = get_valid_move
    @board.place_piece(column, @current_player.piece)
    @last_move_column = column
  end

  def get_valid_move
    loop do
      print 'Choose a column (0-6): '
      column = gets.chomp.to_i

      return column if @board.valid_column?(column) && @board.next_available_row(column)

      puts 'Invalid move. Please try again.'
    end
  end

  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def game_over?
    return false if @last_move_column.nil?

    if @board.winning_move?(@last_move_column, @current_player.piece)
      @winner = @current_player
      return true
    end

    if @board.full?
      @winner = nil
      return true
    end

    false
  end

  def announce_winner
    if @winner
      puts "#{@winner.name} wins!"
    else
      puts "It's a draw!"
    end
  end
end
