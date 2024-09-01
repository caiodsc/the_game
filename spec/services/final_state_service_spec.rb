# frozen_string_literal: true

# spec/final_state_service_spec.rb

require 'rails_helper'

RSpec.describe FinalStateService do
  describe '#call' do
    subject(:call_service) { service.call }

    let(:board) { Board.new(grid: initial_grid) }
    let(:service) { described_class.new(board) }

    context 'when board has a final state' do
      let(:initial_grid) do
        [
          [0, 0, 0, 0, 0],
          [0, 1, 1, 1, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
      end

      let(:final_grid) do
        [
          [0, 0, 0, 0, 0],
          [0, 1, 1, 1, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
      end

      before { call_service }

      it {
        expect(board).to have_attributes(generation: 2, grid: final_grid)
        expect(board).to be_valid
      }
    end

    context 'when board does not have a final state' do
      let(:initial_grid) do
        [
          [0, 1, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [1, 1, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
      end
      let(:max_generations) { 10 }

      before do
        stub_const('Board::MAX_GENERATIONS', max_generations)
        call_service
      end

      it { expect(board).to be_invalid }
      it { expect(board).to have_attributes(generation: max_generations + 1) }
    end
  end
end
