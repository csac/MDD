# encoding: utf-8
class CreateKeywordCategories < ActiveRecord::Migration
  def change
    create_table :keyword_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
