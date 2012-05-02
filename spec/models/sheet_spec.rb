# encoding: UTF-8
require 'spec_helper'

describe Sheet do
  describe 'keywords' do
    let(:sheet) { Fabricate.build(:sheet, keywords: []) }

    it 'should have at last one keywords' do
      sheet.should_not be_valid
      sheet.should have(1).errors_on(:keywords)
    end
  end
end
