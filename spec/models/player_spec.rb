require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should belong_to(:game) }

  describe 'token' do
    it { should have_secure_token(:token) }
    it { should have_db_index(:token).unique(true) }
  end

  describe 'role' do
    it 'provides enum prefix methods' do
      player = Player.new(role: "o")
      expect(player.role_x?).to be false
      expect(player.role_o?).to be true

      player.role = "x"
      expect(player.role_x?).to be true
      expect(player.role_o?).to be false
    end
  end
end
