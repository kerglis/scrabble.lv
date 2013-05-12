# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before :all do
    @dict = Dictionary.new(:xx)

    @dict.add("āēīū")
    @dict.add("aeiu")
    @dict.add("ģķļņ")
    @dict.add("gkln")
    @dict.add("xaybzc")
  end

  context "distinct a from ā, etc" do
    specify { @dict.check?("āēīū").should be_true }
    specify { @dict.check?("ģķļņ").should be_true }
    specify { @dict.check?("āēiu").should be_false }
    specify { @dict.check?("ģķln").should be_false }
  end

  specify { @dict.valid_words_from_chars("āēīūxyz").count.should == 1 }
  specify { Dictionary.find_possible_words_from_chars("abcdefgi").count.should == Dictionary.find_possible_words_from_chars("abcdefg").count }

  context "apply prepositions" do
    specify { Dictionary.apply_prepositions("abcd").should == "abcd" }
    specify { Dictionary.apply_prepositions("abcd", { chars: { 2 => "x", 5 => "y" }, from: 0, to: 5}).should == ["abxcdy"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 2 => "x", 5 => "y" }, from: 0, to: 5}).should == ["abx", "axb", "xaby"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 2 => "x", 3 => "y" }, from: 0, to: 3}).should == ["abxy"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 0 => "x", 1 => "y" }, from: 0, to: 3}).should == ["xyab"] }
    specify { Dictionary.apply_prepositions("abc",  { chars: { 0 => "x", 2 => "y", 4 => "z" }, from: 0, to: 6}).should == ["xaybzc", "yazbc"] }

    specify { @dict.valid_words_from_chars("abc", { chars: { 0 => "x", 2 => "y", 4 => "z" }, from: 0, to: 5 }).include?("xaybzc").should be_true }

  end

end