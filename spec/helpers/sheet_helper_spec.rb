require 'spec_helper'

describe SheetHelper do

  it 'should be false if there is no referer' do
    helper.last_search?('').should be_false
  end

  it 'should be false if did not come from the search' do
    helper.last_search?("http://test.local/toto").should be_false
  end

  it 'should be true if we comes from the search' do
    helper.last_search?("http://test.local/search").should be_true
  end
end

