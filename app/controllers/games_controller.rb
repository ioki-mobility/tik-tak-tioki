# frozen_string_literal: true

class GamesController < ApplicationController
  skip_forgery_protection
  before_action :load_current_player, only: %i[show move]
  before_action :require_current_player!, only: %i[show move]

  before_action :load_current_game, only: [:join]
  before_action :require_current_game!, only: [:join]

  def show
    render json: GameSerializer.new(current_player.game, current_player)
  end

  def create
    result = GameCreator.new.create!
    render_result result
  end

  def join
    result = GameJoiner.new(current_game).join!

    render_result result
  end

  def move
    result = GameUpdater.new(current_player.game, current_player, {
                               next_move_token: params[:next_move_token],
                               field: params[:field]
                             }).update!

    render_result result
  end

  private

  attr_reader :current_player, :current_game

  def render_result(result)
    if result.successful?
      render json: GameSerializer.new(result.game, result.acting_player), status: :created
    else
      error = { error: result.error_message }
      render json: error, status: :unprocessable_entity
    end
  end

  def load_current_player
    @current_player = Player.find_by_token(params[:player_token])
  end

  def require_current_player!
    unless current_player
      error = { error: 'No valid player_token provided' }
      render json: error, status: :unauthorized
    end
  end

  def load_current_game
    @current_game = Game.find_by_name(params[:name])
  end

  def require_current_game!
    unless current_game
      error = { error: 'No valid game name provided' }
      render json: error, status: :not_found
    end
  end
end
