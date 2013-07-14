require_relative "../lib/search_suggester"
require_relative "../lib/letter_position_block"

describe SearchSuggester do
  let(:suggester) { SearchSuggester.new([]) }

  it "gets the next closest position to last picked position" do
    positions = [1, 2, 3]
    current_position = 1
    suggester.get_next_closest_position(positions, current_position).should == 2
  end

  it "returns current position if there's no bigger position" do
    positions = [1, 2, 3]
    current_position = 3
    suggester.get_next_closest_position(positions, current_position).should == 3
  end
  
  it "creates ordered positions from collection of positions based on starting index" do
    all_positions = [[2], [3], [0, 1], [4]]
    ordered = suggester.create_ordered_positions(all_positions, 0)

    ordered.should == [2, 3, 4]
  end

  it "deletes all -1 from the ordered positions" do
    all_positions = [[-1], [2, 3], [3]]
    ordered = suggester.create_ordered_positions(all_positions, 0)

    ordered.should_not include(-1)
  end

  it "returns collection of ordered positions" do
    collection_of_positions = [[2], [3], [0, 1], [4]]
    ordered = suggester.create_collection_of_ordered_positions(collection_of_positions)

    ordered.should == [[2, 3, 4], [3, 4], [0, 4], [4]]
  end

  it "gets all ordered letter positions for a candidate" do
    candidates = ["mmsai"]
    builder = prepare_builder_for_word_and_candidates("sami", candidates)
    suggester = SearchSuggester.new(candidates, builder)

    ordered = suggester.get_collection_of_ordered_positions_for_candidate(candidates[0])

    ordered.should == [[2, 3, 4], [3, 4], [0, 4], [4]]
  end

  it "creates a hash for each candidate and its longest ordered positions" do
    word = "remimance"
    candidates = ["remembrance", "reminiscence"]
    builder = prepare_builder_for_word_and_candidates(word, candidates)
    suggester = SearchSuggester.new(candidates, builder)

    longest_positions = suggester.get_candidates_longest_ordered_positions

    longest_positions[:remembrance].should == 8
    longest_positions[:reminiscence].should == 7
  end

  it "returns the candidate with most common letters in the same order as the searched word" do 
    candidates = ["remembrance", "reminiscence"]
    suggester = SearchSuggester.new(candidates)
    suggestion = suggester.suggest_for("remimance")

    suggestion.should == candidates[0]
  end

  def prepare_builder_for_word_and_candidates(word, candidates)
    builder = LetterPositionBlockBuilder.new
    builder.create_letter_position_block_for_all_candidates(word, candidates)
    builder
  end
end
