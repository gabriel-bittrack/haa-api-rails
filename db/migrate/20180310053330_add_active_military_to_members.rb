class AddActiveMilitaryToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :active_military, :boolean, null: false, default: false
  end
end
