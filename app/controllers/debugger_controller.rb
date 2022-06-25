# frozen_string_literal: true

class DebuggerController < ApplicationController
  def index; end

  def view_game
    redirect_to debugger_path(player_token: params[:player_token])
  end

  def show
    @player = Player.find_by_token!(params[:player_token])
    @game = @player.game
  rescue ActiveRecord::RecordNotFound
    redirect_to :debugger_index, alert: 'Invalid Player Token'
  end
end
