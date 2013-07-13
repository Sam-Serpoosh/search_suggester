require_relative "../lib/letter_position_block_builder"

describe LetterPositionBlockBuilder do
  it "creates a LetterPositionBlock for word based on candidate" do
    subject.create_letter_position_block_for_candidate("abc", "aabbccd")
    block = subject.get_letter_position_block_for_candidate("aabbccd")

    block.position_of_letter(0).should == [0, 1]
    block.position_of_letter(1).should == [2, 3]
    block.position_of_letter(2).should == [4, 5]
  end

  it "sets position to -1 when char doesn't exist in candidate" do
    subject.create_letter_position_block_for_candidate("abc", "bc")
    block = subject.get_letter_position_block_for_candidate("bc")

    block.position_of_letter(0).should == [-1]
  end

  it "creates LetterPositionBlock for all candidates" do
    candidates = ["abdc", "aabbcd"]
    subject.create_letter_position_block_for_all_candidates("abc", candidates)
    block1 = subject.get_letter_position_block_for_candidate("abdc")
    block2 = subject.get_letter_position_block_for_candidate("aabbcd")

    block1.position_of_letter(0).should == [0]
    block1.position_of_letter(2).should == [3]

    block2.position_of_letter(0).should == [0, 1]
    block2.position_of_letter(2).should == [4]
  end
end
