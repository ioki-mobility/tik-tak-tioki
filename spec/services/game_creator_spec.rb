require "rails_helper"

RSpec.describe GameCreator do
  subject { GameCreator.new }

  it 'generates a persisted and valid game' do
    game = subject.create!

    expect(game).to be_persisted
    expect(game).to be_valid
  end
end
