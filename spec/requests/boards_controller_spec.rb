# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BoardsController, type: :request do
  let(:valid_attributes) { { grid: initial_grid } }

  let(:initial_grid) do
    [
      [0, 0, 1, 0, 0],
      [1, 0, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
  end
  let(:height) { 5 }
  let(:width) { 5 }
  let(:zero_generation) { 0 }

  let(:invalid_attributes) { { grid: invalid_grid } }
  let(:invalid_grid) { [[0, 1], [1]] }

  describe 'GET /boards' do
    before { Board.create!(valid_attributes) }

    it 'returns a list of boards' do
      get '/boards'
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
      expect(json_response).to have_attributes(size: 1)
      expect(json_response.first).to include(height:,
                                             width:,
                                             grid: initial_grid,
                                             generation: zero_generation)
    end
  end

  describe 'GET /boards/:id' do
    let(:board) { Board.create!(valid_attributes) }

    it 'returns a specific board' do
      get "/boards/#{board.id}"

      expect(response).to have_http_status(:ok)
      expect(json_response).to include(id: board.id,
                                       height:,
                                       width:,
                                       grid: initial_grid,
                                       generation: zero_generation)
    end
  end

  describe 'POST /boards' do
    let(:valid_params) { { board: { grid: initial_grid.to_json } } }
    let(:invalid_params) { { board: { grid: invalid_grid.to_json } } }

    context 'with valid parameters' do
      it 'creates a new board' do
        expect { post '/boards', params: valid_params }.to change(Board, :count).by(1)
      end

      it 'renders a JSON response with the new board' do
        post '/boards', params: valid_params

        expect(response).to have_http_status(:created)
        expect(json_response).to include(height:,
                                         width:,
                                         grid: initial_grid,
                                         generation: zero_generation)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the new board' do
        post '/boards', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to include(grid: ['must be an array of arrays with consistent width'])
      end
    end
  end

  describe 'POST /boards/:id/next' do
    let(:board) { Board.create!(valid_attributes) }

    let(:first_generation) { 1 }
    let(:first_generation_grid) do
      [
        [0, 1, 0, 0, 0],
        [0, 0, 1, 1, 0],
        [0, 1, 1, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0]
      ]
    end

    context 'with valid parameters' do
      before { stub_const('Board::MAX_GENERATIONS', max_generations) }
      let(:max_generations) { tenth_generation }

      let(:tenth_generation) { 10 }
      let(:tenth_generation_grid) do
        [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 1],
          [0, 0, 0, 1, 1]
        ]
      end

      it 'renders a JSON response with the new board' do
        post "/boards/#{board.id}/next"

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(generation: first_generation, grid: first_generation_grid)
      end

      it 'updates the board to the tenth generation' do
        post "/boards/#{board.id}/next", params: { generations: tenth_generation }

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(generation: tenth_generation, grid: tenth_generation_grid)
      end

      it 'persists the updated board' do
        expect do
          post "/boards/#{board.id}/next"
          board.reload
        end.to change(board, :attributes).to include('generation' => first_generation, 'grid' => first_generation_grid)
      end
    end

    context 'board has reached max number of generations' do
      let(:board) { Board.create!(valid_attributes) }
      let(:max_generations) { 5 }

      before do
        stub_const('Board::MAX_GENERATIONS', max_generations)
        post "/boards/#{board.id}/next", params: { generations: max_generations }
      end

      it 'renders a JSON response with the new board' do
        post "/boards/#{board.id}/next"

        expect(response).to have_http_status(:bad_request)
        expect(json_response).to include(generation: ['exceeded max generations'])
      end

      it 'does not update the board' do
        expect do
          post "/boards/#{board.id}/next"
        end.to_not change(board, :attributes)
      end
    end
  end

  describe 'GET /boards/:id/final_state' do
    let(:board) { Board.create!(valid_attributes) }

    let(:first_generation) { 1 }
    let(:first_generation_grid) do
      [
        [0, 1, 0, 0, 0],
        [0, 0, 1, 1, 0],
        [0, 1, 1, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0]
      ]
    end

    context 'board reaches conclusion within max attempts' do
      let(:final_state_generation) { 12 }
      let(:final_state_grid) do
        [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 1, 1],
          [0, 0, 0, 1, 1]
        ]
      end

      it 'renders a JSON response with the final state of the board' do
        get "/boards/#{board.id}/final_state"

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(generation: final_state_generation, grid: final_state_grid)
      end

      it 'updates the board to the final state' do
        expect do
          get "/boards/#{board.id}/final_state"
          board.reload
        end.to change(board, :attributes).to include('generation' => final_state_generation, 'grid' => final_state_grid)
      end
    end

    context 'board fails to conclude after max attempts' do
      before { stub_const('Board::MAX_GENERATIONS', max_generations) }
      let(:max_generations) { tenth_generation }

      let(:tenth_generation) { 10 }
      let(:tenth_generation_grid) do
        [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 1],
          [0, 0, 0, 1, 1]
        ]
      end

      it 'returns a bad request response with error message' do
        get "/boards/#{board.id}/final_state"

        expect(response).to have_http_status(:bad_request)
        expect(json_response).to include(generation: ['exceeded max generations'])
      end

      it 'does not update the board' do
        expect do
          get "/boards/#{board.id}/final_state"
        end.to_not change(board, :attributes)
      end
    end
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end
end
