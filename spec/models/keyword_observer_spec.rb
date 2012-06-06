# -*- coding: utf-8 -*-
require 'spec_helper'

describe KeywordObserver do

  describe '#after_destroy', search: true do
    let(:keyword)       { Fabricate(:keyword) }
    let(:sheet)         { Fabricate(:sheet) }

    before do
      sheet.keywords << keyword
      sheet.save
      Sheet.refresh_index!
    end

    it 'should reindex the sheets having the keyword we destroy' do
      results = Sheet.search(tags: [keyword.name]).perform.results
      results.size.should eq 1

      keyword.destroy
      sheet.reload

      results = Sheet.search(tags: [keyword.name]).perform.results
      results.size.should eq 0
    end
  end
end
