require 'spec_helper'

describe SheetHelper do

  it 'should be false if there is no last search' do
    helper.last_search?.should be_false
  end

  it 'should be true if there is a last search' do
    session[:last_search] = {}
    helper.last_search?.should be_true
  end
end

