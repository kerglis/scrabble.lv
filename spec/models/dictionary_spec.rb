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

end