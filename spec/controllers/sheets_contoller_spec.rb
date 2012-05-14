# encoding: UTF-8
require 'spec_helper'

describe SheetsController do
  it_should_behave_like "inherit_resources with",
    'sheet',
    %w{new show index edit destroy}

  describe 'create' do
    let(:administrator) { Fabricate :administrator }
    let(:skill_keyword) { Fabricate(:skill_keyword) }
    let(:sheet)         { Fabricate(:sheet) }

    before do
      sign_in(administrator)
    end

    it 'should add a history on sheet creation' do
     expect {
        post :create, sheet: {title: 'A sheet', level: 3, description: 'Something', keyword_ids: [skill_keyword.id]}
     }.to change(History, :count).by(1)

      sheet = Sheet.last
      histories = sheet.histories

      sheet.histories.size.should == 1

      history = histories.first
      history.user.should == administrator
      history.subject.should == sheet
      history.action.should == 'create'
    end

    it 'should add a history on sheet update' do
      expect {
        put :update, id: sheet.id, sheet: {title: 'A new title'}
      }.to change(History, :count).by(1)

      histories = sheet.histories

      sheet.histories.size.should == 1

      history = histories.last
      history.user.should == administrator
      history.subject.should == sheet
      history.action.should == 'update'
    end

  end
end
