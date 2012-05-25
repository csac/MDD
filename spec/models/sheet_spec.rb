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

  describe 'search', search: true do

    describe 'api' do

      let!(:sheet1) { Fabricate(:sheet) }
      let!(:sheet2) { Fabricate(:sheet) }

      before do
        Sheet.refresh_index!
      end

      it 'should return a Search object' do
        Sheet.search.should be_kind_of(Tire::Search::Search)
      end

      it 'should return all the documents' do
        results = Sheet.search.perform.results
        results.size.should == 2
      end

      it 'should paginate documents' do
        results = Sheet.search(page: 1, per_page: 1).perform.results
        results.size.should == 1
        s1 = results.first

        results = Sheet.search(page: 2, per_page: 1).perform.results
        results.size.should == 1
        s2 = results.first

        s1.id.should_not eq s2.id
      end

    end

    context 'with an index on title' do

      let!(:sheet1) { Fabricate(:sheet, title: 'Authentification LDAP') }
      let!(:sheet2) { Fabricate(:sheet, title: "Mise à jour en préprod d'une application ACAI") }

      before do
        Sheet.refresh_index!
      end

      it 'should find 1 document via a query' do
        results = Sheet.search(query: 'Mise à jour').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

    end

    context 'with an index on description' do

      let!(:sheet1) do
        Fabricate(:sheet,
                  title: 'Un titre',
                  description: "Introduction et description de l'architecture")
      end
      let!(:sheet2) do
        Fabricate(:sheet,
                  title: "Un autre titre",
                  description: "Récupération du war dans le FTP")
      end

      before do
        Sheet.refresh_index!
      end

      it 'should find 1 document via a query' do
        results = Sheet.search(query: 'ftp').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

    end

    context 'with an index on update_to_date' do

      let!(:sheet1) { Fabricate(:sheet, up_to_date: true) }
      let!(:sheet2) { Fabricate(:sheet, up_to_date: false) }

      before do
        Sheet.refresh_index!
      end

      it 'should find 1 document via the up_to_date filter' do
        results = Sheet.search(up_to_date: 'false').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

    end

    context 'with an index on level' do

      let!(:sheet1) { Fabricate(:sheet, level: 1) }
      let!(:sheet2) { Fabricate(:sheet, level: 2) }

      before do
        Sheet.refresh_index!
      end

      it 'should find 1 document via the up_to_date filter' do
        results = Sheet.search(level: 2).perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

    end

    context 'with an index on updated_at' do

      let!(:sheet1) { Fabricate(:sheet) }
      let!(:sheet2) { Fabricate(:sheet, updated_at: sheet1.updated_at - 1.day) }
      let!(:sheet3) { Fabricate(:sheet, updated_at: sheet1.updated_at.beginning_of_week - 1.day) }
      let!(:sheet4) { Fabricate(:sheet, updated_at: sheet1.updated_at.beginning_of_month - 1.day) }

      before do
        Sheet.refresh_index!
      end

      it 'should find 1 document updated today' do
        results = Sheet.search(updated: 'today').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet1.id
      end

      it 'should find 1 document updated yesterday' do
        results = Sheet.search(updated: 'yesterday').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

      it 'should find 1 document updated 1 week ago' do
        results = Sheet.search(updated: 'this-week').perform.results
        results.size.should eq 2

        ids = results.map(&:id)
        ids.should include(sheet1.id)
        ids.should include(sheet2.id)
        ids.should_not include(sheet3.id)
      end

      it 'should find 1 document updated 1 month ago' do
        results = Sheet.search(updated: 'this-month').perform.results
        results.size.should eq 3

        ids = results.map(&:id)
        ids.should include(sheet1.id)
        ids.should include(sheet2.id)
        ids.should include(sheet3.id)
        ids.should_not include(sheet4.id)
      end

    end

    context 'with an index on keywords' do

      let!(:keyword1) { Fabricate(:keyword) }
      let!(:sheet1)   { Fabricate(:sheet)   }
      let!(:sheet2) do
        s = Fabricate(:sheet)
        s.keywords << Fabricate(:keyword, name: 'documentation')
        s
      end

      before do
        sheet2.save
        Sheet.refresh_index!
      end

      it 'should find 1 document via a query' do
        results = Sheet.search(query: 'documentation').perform.results
        results.size.should eq 1
        results.first.id.should eq sheet2.id
      end

      it 'should have tags facets' do
        facets = Sheet.search.perform.results.facets['tags']['terms']
        facets.size.should eq 3

        facets.should include({'term' => sheet1.keywords.first.name, 'count' => 1})
        facets.should include({'term' => sheet2.keywords.first.name, 'count' => 1})
        facets.should include({'term' => 'documentation', 'count' => 1})
      end

    end

  end
end
