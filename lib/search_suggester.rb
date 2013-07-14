require_relative "./letter_position_block_builder"

class SearchSuggester
  def initialize(dictionary, letter_position_block_builder=LetterPositionBlockBuilder.new)
    @dictionary = dictionary
    @builder = letter_position_block_builder
  end

  def suggest_for(word)
    @builder.create_letter_position_block_for_all_candidates(word, @dictionary)
    candidates_longest_ordered_positions = get_candidates_longest_ordered_positions
    longest_common_letters = candidates_longest_ordered_positions.values.max
    candidates_longest_ordered_positions.select do |candidate, longest_ordered_positions|
      longest_ordered_positions == longest_common_letters
    end.keys.first.to_s
  end

  def get_candidates_longest_ordered_positions
    candidates_longest_ordered_positions = {}
    @dictionary.each do |candidate|
      ordered_positions = get_collection_of_ordered_positions_for_candidate(candidate)
      longest_ordered_positions = ordered_positions.map { |positions| positions.length }.max
      candidates_longest_ordered_positions[candidate.to_sym] = longest_ordered_positions
    end
    candidates_longest_ordered_positions
  end

  def get_collection_of_ordered_positions_for_candidate(candidate)
    block = @builder.get_letter_position_block_for_candidate(candidate)
    collection_of_positions = []
    block.letters_positions.each do |letter_index, positions|
      collection_of_positions << positions
    end

    create_collection_of_ordered_positions(collection_of_positions)
  end

  def create_collection_of_ordered_positions(collection_of_positions)
    collection_of_ordered_positions = []
    (0...collection_of_positions.length).each do |starting_index|
    collection_of_ordered_positions << create_ordered_positions(collection_of_positions, starting_index)
    end

    collection_of_ordered_positions
  end

  def create_ordered_positions(collection_of_positions, index)
    current_position = collection_of_positions[index].min
    ordered_positions = [current_position]
    ((index + 1)...collection_of_positions.length).each do |idx|
      new_position = get_next_closest_position(collection_of_positions[idx], current_position)
      ordered_positions << new_position if current_position != new_position
      current_position = new_position
    end
    ordered_positions.delete(-1)
    ordered_positions
  end

  def get_next_closest_position(positions, last_picked)
    positions.sort!.each { |pos| return pos if pos > last_picked }
    return last_picked
  end
end
