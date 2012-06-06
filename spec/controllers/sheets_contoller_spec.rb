# encoding: UTF-8
require 'spec_helper'

describe SheetsController, search: true do
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

  describe 'show' do

    let(:sheet1) { Fabricate(:sheet, title: 'First')  }
    let(:sheet2) { Fabricate(:sheet, title: 'Second', updated_at: sheet1.updated_at - 1.hour) }
    let(:sheet3) { Fabricate(:sheet, title: 'Third', updated_at: sheet1.updated_at - 2.hour) }

    before do
      sheet1.save
      sheet2.save
      sheet3.save
      Sheet.refresh_index!

      @search_uri = "http://#{request.host}/search?query=''"
      request.env['HTTP_REFERER'] = @search_uri
    end

    it 'should return results of the last search' do
      last_search_results = controller.search_results(@search_uri).to_a
      search_results      = Sheet.search.perform.results.to_a

      last_search_results.should eq search_results
    end

    it 'should return the previous result of the last search' do
      get :show, id: sheet2.id
      controller.previous_result.should eq sheet1
    end

    it 'should return the next result of the last search' do
      get :show, id: sheet2.id
      controller.next_result.should eq sheet3
    end

    it 'should return nil when where are the first result of the last search' do
      get :show, id: sheet1.id
      controller.previous_result.should be_nil
    end

    it 'should return nil when where are the last result of the last search' do
      get :show, id: sheet3.id
      controller.next_result.should be_nil
    end
  end
end
