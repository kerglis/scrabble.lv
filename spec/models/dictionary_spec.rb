# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before :all do
    @dict = Dictionary.new(:xx)
  end

  context "distinct a from ā, etc" do
    before do
      @dict.add("āēīū")
      @dict.add("aeiu")
      @dict.add("ģķļņ")
      @dict.add("gkln")
    end

    specify { @dict.check?("āēīū").should be_true }
    specify { @dict.check?("ģķļņ").should be_true }
    specify { @dict.check?("āēiu").should be_false }
    specify { @dict.check?("ģķln").should be_false }
    specify { @dict.valid_words_from_chars("āēīūxyz").count.should == 1 }
  end

  specify { Dictionary.find_possible_words_from_chars("abcdefgi").count.should == Dictionary.find_possible_words_from_chars("abcdefg").count }

  context "string functions" do
    context "insert_ch" do
      specify { "abc".insert_ch(0, "x").should == "xabc" }
      specify { "abc".insert_ch(1, "x").should == "axbc" }
      specify { "abc".insert_ch(4, "x").should == "abc" }

      it "bang! version" do
        @abc = "abc"
        @abc.insert_ch!(4, "x").should == nil
        @abc.should == "abc"
        @abc.insert_ch!(3, "x").should == true
        @abc.should == "abcx"
      end
    end

    context "insert_chars_at" do
      before do
        @chars = {1 => "x", 3 => "y"}
      end

      specify { "abc".insert_chars_at(0, @chars).should == "axbyc" }
      specify { "abc".insert_chars_at(1, @chars).should == "abxcy" }
      specify { "abc".insert_chars_at(2, @chars).should == "abcx" }
      specify { "abc".insert_chars_at(3, @chars).should == "abc" }

      it "bang! version" do
        @abc = "abc"
        @abc.insert_chars_at!(0, @chars).should be true
        @abc.should == "axbyc"

        @abc = "abc"
        @abc.insert_chars_at!(3, @chars).should be_nil
        @abc.should == "abc"
      end
    end

  end

  context "apply prepositions" do
    specify { Dictionary.apply_prepositions("abcd").should == "abcd" }
    specify { Dictionary.apply_prepositions("abcd", { chars: { 2 => "x", 5 => "y" }, from: 0, to: 5}).map{|x| x.split("@").first }.should == ["abxcdy"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 2 => "x", 5 => "y" }, from: 0, to: 5}).map{|x| x.split("@").first }.should == ["abx", "axb", "xaby"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 2 => "x", 3 => "y" }, from: 0, to: 3}).map{|x| x.split("@").first }.should == ["abxy"] }
    specify { Dictionary.apply_prepositions("ab",   { chars: { 0 => "x", 1 => "y" }, from: 0, to: 3}).map{|x| x.split("@").first }.should == ["xyab"] }
    specify { Dictionary.apply_prepositions("abc",  { chars: { 0 => "x", 2 => "y", 4 => "z" }, from: 0, to: 6}).map{|x| x.split("@").first }.should == ["xaybzc", "yazbc"] }
  end

  context "find valid words" do
    before do
      @dict.add("xay")
      @dict.add("xaybz")
      @dict.add("xey")
      @dict.add("ybz")
    end

    specify { @dict.valid_words_from_chars("abcdefi", { chars: { 0 => "x", 2 => "y", 4 => "z" }, from: 0, to: 5 }).count.should == 4 }
  end

end