# encoding: UTF-8
require 'spec_helper'

describe History do
  describe "have a subject and an action with timestamp" do
    it 'user create a sheet' do
      h = Fabricate(:history)
      h.subject.class.find(h.subject.id).should_not be_nil
      h.user.class.find(h.user.id).should_not be_nil
      h.action.should eq('create')
    end
  end
end
