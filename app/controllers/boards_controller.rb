# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :set_board, only: %i[show next final_state]

  def index
    @boards = Board.all

    render json: @boards
  end

  # GET /boards/1
  def show
    render json: @board
  end

  # POST /boards
  def create
    grid = JSON.parse(params.dig(:board, :grid))

    @board = Board.new(grid:)

    if @board.save
      render json: @board, status: :created
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  def next
    generations = Integer(params[:generations] || 1)

    GenerationService.new(@board).next(generations)

    if @board.save
      render json: @board, status: :ok
    else
      render json: @board.errors, status: :bad_request
    end
  end

  def final_state
    FinalStateService.new(@board).call

    if @board.save
      render json: @board, status: :ok
    else
      render json: @board.errors, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_board
    @board = Board.find(params[:id])
  end
end
