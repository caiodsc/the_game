# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerationService, type: :service do
  let(:board) { Board.new(grid: initial_grid) }

  describe '#next' do
    subject(:call_service) { described_class.new(board).next(leaps) }

    context 'with a single leap' do
      let(:leaps) { 1 }

      context 'when starting with a blinker pattern' do
        let(:initial_grid) do
          [
            [0, 0, 0, 0, 0],
            [0, 1, 1, 1, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        let(:expected_grid) do
          [
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        it 'transforms into a vertical blinker' do
          expect { call_service }.to change(board, :grid).from(initial_grid).to(expected_grid)
        end
        it { expect { call_service }.to change(board, :generation).from(0).to(1) }
      end

      context 'when starting with a block pattern (still life)' do
        let(:initial_grid) do
          [
            [0, 1, 1, 0],
            [0, 1, 1, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
          ]
        end

        it 'remains the same in the next generation' do
          expect { call_service }.to_not change(board, :grid)
        end
        it { expect { call_service }.to change(board, :generation).from(0).to(1) }
      end
    end

    context 'with multiple leaps' do
      let(:leaps) { 2 }

      context 'when start        ing with a glider pattern' do
        let(:initial_grid) do
          [
            [0, 0, 1, 0, 0],
            [1, 0, 1, 0, 0],
            [0, 1, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        let(:expected_grid) do
          [
            [0, 0, 1, 0, 0],
            [0, 0, 0, 1, 0],
            [0, 1, 1, 1, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        it 'advances the board correctly after 2 leaps' do
          expect { call_service }.to change(board, :grid).from(initial_grid).to(expected_grid)
        end
        it { expect { call_service }.to change(board, :generation).from(0).to(2) }
      end

      context 'when starting with a lightweight spaceship pattern' do
        let(:initial_grid) do
          [
            [0, 0, 0, 0, 0],
            [0, 1, 1, 1, 0],
            [1, 1, 1, 1, 0],
            [0, 1, 1, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        let(:expected_grid) do
          [
            [0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0],
            [1, 1, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]
        end

        it 'advances the board correctly after 2 leaps' do
          expect { call_service }.to change(board, :grid).from(initial_grid).to(expected_grid)
        end
        it { expect { call_service }.to change(board, :generation).from(0).to(2) }
      end
    end
  end
end
