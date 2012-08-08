class AddSlugToSheets < ActiveRecord::Migration
  def change
    add_column :sheets, :slug, :string
    add_index :sheets, :slug
  end
end
