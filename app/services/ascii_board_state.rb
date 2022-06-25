# frozen_string_literal: true

class AsciiBoardState
  VALUES = %w[x o f].freeze

  TEMPLATE = ['|---+---+---|',
              '| 0 | 1 | 2 |',
              '|---+---+---|',
              '| 3 | 4 | 5 |',
              '|---+---+---|',
              '| 6 | 7 | 8 |',
              '|---+---+---|'].freeze

  def self.encode(board)
    new.encode(board)
  end

  def self.decode(ascii_art)
    new.decode(ascii_art)
  end

  def encode(board)
    # {
    #   "0" => "x",
    #   "1" => "f",
    #   "2" => "o",
    #   ...
    # }
    sub_values = board.each_with_object({}).with_index { |(val, acc), index| acc[index.to_s] = val }

    TEMPLATE.map { |line| line.gsub(/[0-8]/, sub_values) }
  end

  def decode(ascii_art)
    lines = ascii_art.split("\n")
    value_lines = [lines[1], lines[3], lines[5]]

    value_lines.flat_map { |line| extract_line_values(line) }
  end

  def extract_line_values(line)
    values = []
    cell_value_found = true

    line.chars.each do |char|
      if char == '|' && cell_value_found == false
        values << 'f'
      elsif char == '|' && cell_value_found == true
        cell_value_found = false
      elsif char.downcase.in?(VALUES) && cell_value_found == false
        cell_value_found = true
        values << char
      elsif char.downcase.in?(VALUES) && cell_value_found == true
        raise 'Error, two values per cell found'
      end
    end

    values
  end
end
