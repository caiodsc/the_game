# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:height) }
    it { is_expected.to validate_presence_of(:width) }
    it { is_expected.to validate_presence_of(:grid) }

    it { is_expected.to validate_numericality_of(:height).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:width).is_greater_than(0) }

    context 'when grid width is inconsistent' do
      let(:invalid_grid) { [[1, 0, 1], [0, 1], [1, 0, 1]] }
      subject(:board) { described_class.new(grid: invalid_grid) }

      it { is_expected.to be_invalid }
      it { is_expected.to_not allow_value(invalid_grid).for(:grid).with_message('must be an array of arrays with consistent width') }
    end

    context 'when grid width is consistent' do
      let(:valid_grid) { [[1, 0, 1], [0, 1, 0], [1, 0, 1]] }
      subject { described_class.new(grid: valid_grid) }

      it { is_expected.to be_valid }
    end
  end

  describe 'methods' do
    describe 'token' do
      subject(:token) { described_class.new(grid:).token }

      let(:grid) do
        [
          [0, 0, 0],
          [1, 1, 1],
          [0, 0, 0]
        ]
      end

      it { is_expected.to eq(Digest::MD5.hexdigest(grid.join)) }
    end
  end

  describe 'callbacks' do
    context 'after initialize' do
      let(:grid) { [[1, 0], [0, 1]] }
      subject(:board) { described_class.new(grid:) }

      it 'sets the correct height and width' do
        is_expected.to have_attributes(
          height: grid.size,
          width: grid.first.size
        )
      end
    end
  end
end
