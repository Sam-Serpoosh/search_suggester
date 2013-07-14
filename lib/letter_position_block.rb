class LetterPositionBlock
  attr_reader :letters_positions

  def initialize
    @letters_positions = {}
  end

  def add_position_for_letter(letter_index, position)
    (@letters_positions[letter_index] ||= []) << position
  end
end
