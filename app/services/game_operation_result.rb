# frozen_string_literal: true

class GameOperationResult
  attr_accessor :game,
                :acting_player,
                :success,
                :error_message

  def initialize(game, acting_player)
    self.game = game
    self.acting_player = acting_player
  end

  def success!
    self.success = true
    self
  end

  def error!(message)
    self.success = false
    self.error_message = message
    self
  end

  def successful?
    !!success
  end

  def failed?
    !successful?
  end
end
