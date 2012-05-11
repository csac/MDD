# encoding: UTF-8
# == Schema Information
#
# Table name: sheets
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  level       :integer
#  up_to_date  :boolean
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe Sheet do
  describe 'keywords' do
    let(:skill_keyword) { Fabricate(:skill_keyword) }
    let(:keyword)       { Fabricate(:keyword) }
    let(:sheet)         { Fabricate(:sheet) }

    it 'should not be valid when not having a skill keyword' do
      sheet.keywords = [keyword]
      sheet.should_not be_valid
      sheet.should have(1).errors_on(:keywords)
    end

    it 'should be valid when having at least one skill keyword' do
      sheet.keywords << skill_keyword
      sheet.should be_valid
    end
  end
end
