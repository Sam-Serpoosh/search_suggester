class LetterPositionBlock
  attr_reader :letter_positions

  def initialize
    @letter_positions = {}
  end

  def set_position_for_letter(letter_position, position)
    (@letter_positions[letter_position] ||= []) << position
  end

  def position_of_letter(letter_position)
    @letter_positions[letter_position]
  end
end
