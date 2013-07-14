require_relative "../lib/search_suggester"
require_relative "./file_reader"

class SearchSuggesterVerifier
  def initialize(input_reader=InputReader.new("SAMPLE_INPUT.txt"), 
                 output_reader=OutputReader.new("SAMPLE_OUTPUT.txt"))
    @input_reader = input_reader
    @output_reader = output_reader
  end

  def collect_all_suggestions
    suggested_words = []
    all_words = @input_reader.read_lines
    search_section_index = 1

    while search_section_index < all_words.length
      searched_word, dictionary = grab_searched_and_dictionary(all_words, search_section_index)
      suggested_words << SearchSuggester.new(dictionary).suggest_for(searched_word)

      search_section_index += 3
    end
    suggested_words
  end

  def verify
    suggested_words = collect_all_suggestions
    expected_suggestions = @output_reader.read_lines
    check_equality_of(expected_suggestions, suggested_words)
  end

  private

  def grab_searched_and_dictionary(all_words, current_index)
    searched_word = all_words[current_index]
    (dictionary ||= []) << all_words[current_index + 1]
    dictionary << all_words[current_index + 2]

    [searched_word, dictionary]
  end

  def check_equality_of(expected_array, actual_array)
    (0...expected_array.length).each do |index|
      if expected_array[index] != actual_array[index]
        raise "expected: #{expected_array[index]}, got: #{actual_array[index]}"
      end
    end
    puts "PASSED!!!"
  end
end
