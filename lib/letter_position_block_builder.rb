require_relative "./letter_position_block"

class LetterPositionBlockBuilder
  def initialize
    @candidates_block = {}
  end

  def create_letter_position_block_for_all_candidates(word, candidates)
    candidates.each do |candidate|
      create_letter_position_block_for_candidate(word, candidate)
    end
  end

  def create_letter_position_block_for_candidate(word, candidate)
    block = LetterPositionBlock.new
    char_index = 0
    word.each_char do |ch|
      positions = possible_positions_for_char_in_candidate(candidate, ch)
      positions.each { |pos| block.add_position_for_letter(char_index, pos) }
      char_index += 1
    end

    @candidates_block[candidate.to_sym] = block
  end

  def get_letter_position_block_for_candidate(candidate)
    @candidates_block[candidate.to_sym]
  end

  private

  def possible_positions_for_char_in_candidate(word, char)
    positions = []
    idx = 0
    while idx < word.length
      positions << idx if char == word[idx]
      idx += 1
    end
    positions.empty? ? [-1] : positions
  end
end
