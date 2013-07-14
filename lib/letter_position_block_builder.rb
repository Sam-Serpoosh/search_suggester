require_relative "./letter_position_block"

class LetterPositionBlockBuilder
  def initialize
    @candidates_letter_positions_block = {}
  end

  def create_letter_position_block_for_all_candidates(word, candidates)
    candidates.each do |candidate|
      create_letter_position_block_for_candidate(word, candidate)
    end
  end

  def create_letter_position_block_for_candidate(word, candidate)
    block = LetterPositionBlock.new
    letter_index = 0
    word.each_char do |letter|
      positions = possible_positions_for_letter_in_candidate(letter, candidate)
      positions.each { |pos| block.add_position_for_letter(letter_index, pos) }
      letter_index += 1
    end

    @candidates_letter_positions_block[candidate.to_sym] = block
  end

  def get_letter_position_block_for_candidate(candidate)
    @candidates_letter_positions_block[candidate.to_sym]
  end

  private

  def possible_positions_for_letter_in_candidate(letter, word)
    positions = []
    (0...word.length).each do |index|
      positions << index if letter == word[index]
    end
    positions.empty? ? [-1] : positions
  end
end
