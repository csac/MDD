class AddRolesToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :roles_mask
    end
  end
end

