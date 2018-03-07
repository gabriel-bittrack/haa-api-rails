class AlterFriends < ActiveRecord::Migration[5.1]
  def change
    add_column :friends, :full_name, :string
    add_column :friends, :first_name, :string
    add_column :friends, :last_name, :string
    add_column :friends, :city, :string
    add_column :friends, :state, :string
    add_column :friends, :country, :string
    add_column :friends, :title, :string
    add_column :friends, :current_org, :string
  end
end
