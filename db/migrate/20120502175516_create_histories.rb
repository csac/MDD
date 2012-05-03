class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :subject_type
      t.string :action
      t.timestamps
    end
  end
end
