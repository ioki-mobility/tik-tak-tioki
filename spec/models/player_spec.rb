require 'rails_helper'

RSpec.describe Player, type: :model do
  it { should belong_to(:game) }

  describe 'token' do
    it { should have_secure_token(:token) }
    it { should have_db_index(:token).unique(true) }
  end

  describe 'role' do
    xit do
      should define_enum_for(:role).
               backed_by_column_of_type(:string).
               with_suffix.
               with_values({ o: 'o', x: 'x' })
    end
  end

  describe 'validations' do
    subject(:player) do
      GameCreator.new.build.players.first
    end
  end
end
