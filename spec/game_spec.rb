# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'

describe Game do
  subject(:game) { described_class.new }
  let(:player1) { instance_double(Player, name: 'Player 1', piece: :red) }
  let(:player2) { instance_double(Player, name: 'Player 2', piece: :black) }

  before do
    allow(Player).to receive(:new).with('Player 1', :red).and_return(player1)
    allow(Player).to receive(:new).with('Player 2', :black).and_return(player2)
  end

  describe '#initialize' do
    it 'creates a board' do
      expect(game.board).to be_a(Board)
    end

    it 'creates two players' do
      expect(game.player1).to eq(player1)
      expect(game.player2).to eq(player2)
    end

    it 'sets player1 as the current player' do
      expect(game.current_player).to eq(player1)
    end
  end

  describe '#switch_player' do
    it 'switches from player1 to player2' do
      game.switch_player
      expect(game.current_player).to eq(player2)
    end

    it 'switches from player2 to player1' do
      game.instance_variable_set(:@current_player, player2)
      game.switch_player
      expect(game.current_player).to eq(player1)
    end
  end

  describe '#game_over?' do
    let(:board) { instance_double(Board) }

    before do
      game.instance_variable_set(:@board, board)
    end

    context 'when someone has won' do
      it 'returns true' do
        allow(board).to receive(:winning_move?).and_return(true)
        expect(game.game_over?).to be true
      end
    end

    context 'when the board is full' do
      it 'returns true' do
        allow(board).to receive(:winning_move?).and_return(false)
        allow(board).to receive(:full?).and_return(true)
        expect(game.game_over?).to be true
      end
    end

    context 'when no one has won and the board is not full' do
      it 'returns false' do
        allow(board).to receive(:winning_move?).and_return(false)
        allow(board).to receive(:full?).and_return(false)
        expect(game.game_over?).to be false
      end
    end
  end
end
