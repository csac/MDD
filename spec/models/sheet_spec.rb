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
    let(:sheet) { Fabricate.build(:sheet, keywords: []) }

    it 'should have at last one keywords' do
      sheet.should_not be_valid
      sheet.should have(1).errors_on(:keywords)
    end
  end
end
