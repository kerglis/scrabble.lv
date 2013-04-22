# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before do
    @dict_1 = Dictionary.create(:word => "āēīū", :locale => :lv)
    @dict_2 = Dictionary.create(:word => "aeiu", :locale => :lv)
    @dict_3 = Dictionary.create(:word => "ģķļņ", :locale => :lv)
    @dict_4 = Dictionary.create(:word => "gkln", :locale => :lv)
  end

  context "distinct a from ā, etc" do
    specify { Dictionary.where(:word => "āēīū").count.should == 1 }
    specify { Dictionary.where(:word => "āēiu").count.should == 0 }
    specify { Dictionary.where(:word => "ģķļņ").count.should == 1 }
    specify { Dictionary.where(:word => "ģķln").count.should == 0 }
  end

  context "word length" do
    specify { @dict_1.word.length.should == 4 }
    specify { @dict_2.word.length.should == 4 }
    specify { @dict_3.word.length.should == 4 }
    specify { @dict_4.word.length.should == 4 }
  end

end