# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game

  has_secure_token

  enum :role, {
    o: 'o',
    x: 'x'
  }, scopes: false, prefix: :role
end
