class CreateKeywordSheetJoinTable < ActiveRecord::Migration
  def change
    create_table :keywords_sheets, id: false do |t|
      t.integer :keyword_id
      t.integer :sheet_id
    end
  end
end
