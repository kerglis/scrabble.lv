# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before :all do
    @dict = Dictionary.new(:lv)

    @dict.add("āēīū")
    @dict.add("aeiu")
    @dict.add("ģķļņ")
    @dict.add("gkln")
    @dict.add("axbycz")
    @dict.add("xaybzc")
  end

  after :all do
    @dict.remove("āēīū")
    @dict.remove("aeiu")
    @dict.remove("ģķļņ")
    @dict.remove("gkln")
    @dict.remove("axbycz")
    @dict.remove("xaybzc")
  end

  context "distinct a from ā, etc" do
    specify { @dict.check?("āēīū").should be_true }
    specify { @dict.check?("ģķļņ").should be_true }
    specify { @dict.check?("āēiu").should be_false }
    specify { @dict.check?("ģķln").should be_false }
  end

  specify { @dict.valid_words_from_chars("āēīūxyw").count.should == 1 }
  specify { Dictionary.find_possible_words_from_chars("abcdefgi").count.should == Dictionary.find_possible_words_from_chars("abcdefg").count }

  context "apply prepositions" do
    specify { Dictionary.apply_prepositions("test").should == "test" }
    specify { Dictionary.apply_prepositions("test", { chars: { 2 => "k", 5 => "i" }}).should == ["teksti"] }
    specify { Dictionary.apply_prepositions("te",   { chars: { 2 => "k", 5 => "i" }}).should == ["tek"] }
    specify { Dictionary.apply_prepositions("te",   { chars: { 2 => "ļ", 3 => "ā" }}).should == ["teļā"] }
    specify { Dictionary.apply_prepositions("te",   { chars: { 0 => "a", 1 => "s" }}).should == ["aste"] }
    specify { Dictionary.apply_prepositions("xyz",  { chars: { 0 => "a", 2 => "b", 4 => "c" }, from: 0, to: 2}).should == ["axbycz", "xaybzc", "xyazb"] }
    specify { Dictionary.apply_prepositions("xyz",  { chars: { 0 => "a", 2 => "b", 4 => "c" }, from: 1, to: 3}).should == ["xaybzc", "xyazb", "xyza" ] }

    specify { @dict.valid_words_from_chars("xyz", { chars: { 0 => "a", 2 => "b", 4 => "c" }, from: 0, to: 2 }).include?("axbycz").should be_true }

  end

end