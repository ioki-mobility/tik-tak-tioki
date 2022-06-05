class NameGenerator
  def generate
    [
      self.class.predicates.sample,
      self.class.objects.sample,
      random_padded_number_string
    ].join("-")
  end

  def random_padded_number_string
    Random.rand(9999).to_s.rjust(4, "0")
  end

  def self.predicates
    @predicates ||= read_words_from_file("predicates.txt")
  end

  def self.objects
    @objects ||= read_words_from_file("objects.txt")
  end

  private

  def self.read_words_from_file(filename)
    File.read(Rails.root.join("lib/words", filename)).split
  end
end
