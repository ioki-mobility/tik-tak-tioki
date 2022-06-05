require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should have_secure_token(:token) }
  it { should have_db_index(:token).unique(true) }

  describe 'validations' do
    it 'is a valid model by default' do
      expect(Player.new).to be_valid
    end
  end
end
