require "rails_helper"

RSpec.describe NameGenerator do
  context 'caching dictionary files' do
    it 'only reads the predicates files once' do
      expect(File).to receive(:read).once.and_call_original
      NameGenerator.predicates
      NameGenerator.predicates
    end

    it 'only reads the objects files once' do
      expect(File).to receive(:read).once.and_call_original
      NameGenerator.objects
      NameGenerator.objects
    end
  end

  context 'random generation' do
    it 'generates a word-word-number{4} pattern' do
      name = NameGenerator.new.generate
      expect(name).to match(/[a-z]+-[a-z]+-[0-9]{4,4}+/)
    end

    it 'generates a unique name' do
      names = 10.times.map { NameGenerator.new.generate }

      names.each_cons(2) do |a, b|
        expect(a).to_not eql(b)
      end
    end
  end
end
