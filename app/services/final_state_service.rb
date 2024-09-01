# frozen_string_literal: true

class FinalStateService
  attr_reader :board

  def initialize(board)
    @board = board
    @history = Set.new([board.token])
  end

  def call
    while @board.valid?
      @board = GenerationService.new(@board).next

      break if repeated?(@board.token)
    end

    @board
  end

  private

  def repeated?(token)
    @history.add?(token).nil?
  end
end
