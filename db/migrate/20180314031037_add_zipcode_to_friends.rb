class AddZipcodeToFriends < ActiveRecord::Migration[5.1]
  def change
    add_column :friends, :zipcode, :string
  end
end
