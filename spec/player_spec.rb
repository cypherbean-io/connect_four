# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new('Player 1', :red) }

  describe '#initialize' do
    it 'sets the name' do
      expect(player.name).to eq('Player 1')
    end

    it 'sets the piece color' do
      expect(player.piece).to eq(:red)
    end
  end
end
