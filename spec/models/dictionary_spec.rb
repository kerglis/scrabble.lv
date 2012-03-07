# encoding: UTF-8

require 'spec_helper'
describe Dictionary do

  before(:each) do
    Dictionary.destroy_all
    @dict_1 = Dictionary.create(:word => "āēīū", :locale => :lv)
    @dict_2 = Dictionary.create(:word => "aeiu", :locale => :lv)
    @dict_3 = Dictionary.create(:word => "ģķļņ", :locale => :lv)
    @dict_4 = Dictionary.create(:word => "gkln", :locale => :lv)
  end

  after(:each) do
    Dictionary.destroy_all
  end

  it "shall distinct a from ā, etc" do
    Dictionary.where(:word => "āēīū").count.should == 1
    Dictionary.where(:word => "āēiu").count.should == 0
    Dictionary.where(:word => "ģķļņ").count.should == 1
    Dictionary.where(:word => "ģķln").count.should == 0
  end

  it "shall get correct word length" do
    @dict_1.word.length.should == 4
    @dict_2.word.length.should == 4
    @dict_3.word.length.should == 4
    @dict_4.word.length.should == 4
  end
  
end