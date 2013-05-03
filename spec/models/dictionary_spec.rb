# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before :all do
    @dict = Dictionary.new

    @dict.add("āēīū")
    @dict.add("aeiu")
    @dict.add("ģķļņ")
    @dict.add("gkln")
  end

  after :all do
    @dict.remove("āēīū")
    @dict.remove("aeiu")
    @dict.remove("ģķļņ")
    @dict.remove("gkln")
  end

  context "distinct a from ā, etc" do
    specify { @dict.check?("āēīū").should be_true }
    specify { @dict.check?("ģķļņ").should be_true }
    specify { @dict.check?("āēiu").should be_false }
    specify { @dict.check?("ģķln").should be_false }
  end

  specify { @dict.valid_words_from_chars("āēīūxyw").count.should == 1 }

  context "apply prepositions" do
    specify { Dictionary.apply_prepositions("test").should == "test" }
    specify { Dictionary.apply_prepositions("test", {:chars => { "k" => 2, "i" => 5 }}).should == ["teksti"] }
    specify { Dictionary.apply_prepositions("te", {:chars => { "k" => 2, "i" => 5 }}).should == ["tek"] }
    specify { Dictionary.apply_prepositions("te", {:chars => { "ļ" => 2, "ā" => 3 }}).should == ["teļā"] }
    specify { Dictionary.apply_prepositions("te", {:chars => { "a" => 0, "s" => 1 }}).should == ["aste"] }
    specify { Dictionary.apply_prepositions("te", {:chars => { "a" => 0, "s" => 1 }}).should == ["aste"] }
    specify { Dictionary.apply_prepositions("xyz", {:chars => { "a" => 0, "b" => 2, "c" => 4 }, :from => 0, :to => 2}).should == ["axbycz", "xaybzc", "xyazb"] }
  end

end