# encoding: utf-8
class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string     :title
      t.text       :description
      t.integer    :level
      t.boolean    :up_to_date

      t.timestamps
    end
  end
end
