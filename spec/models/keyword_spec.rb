# -*- coding: utf-8 -*-
require 'spec_helper'

describe Keyword do

  describe 'sheets' do
    let(:keyword)       { Fabricate(:keyword) }
    let(:sheet)         { Fabricate(:sheet) }

    before do
      sheet.keywords << keyword
    end

    it 'should remove the keyword from sheets when detroying it' do
      sheet.keywords.size.should eq 2
      keyword.destroy
      sheet.reload
      sheet.keywords.size.should eq 1
      sheet.keywords.first.id.should_not eq keyword.id
    end

  end
end

