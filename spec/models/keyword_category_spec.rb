# -*- coding: utf-8 -*-
require 'spec_helper'

describe KeywordCategory do

  describe 'keywords' do
    let(:keyword)  { Fabricate(:keyword) }
    let(:category) { keyword.keyword_category }

    it 'should destroy the keyword when destroying it category' do
      category.destroy
      Keyword.all.size.should eq 0
    end

  end
end

