# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicGameSerializer do
  let(:game) { Factory.create_game! }

  subject(:result) { described_class.new(game).as_json }

  it 'renders the name' do
    expect(subject[:name]).to eql(game.name)
    expect(subject[:name]).to be_a(String)
  end

  it 'renders timestamps' do
    expect(subject[:created_at]).to eql(game.created_at)
    expect(subject[:created_at]).to be_a(ActiveSupport::TimeWithZone)
  end

  it 'renders just two attributes' do
    expect(subject.keys).to eql([:name, :created_at])
  end
end
