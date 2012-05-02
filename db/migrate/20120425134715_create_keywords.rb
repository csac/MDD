# encoding: utf-8
class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name
      t.references :keyword_category

      t.timestamps
    end
    add_index :keywords, :keyword_category_id
  end
end
