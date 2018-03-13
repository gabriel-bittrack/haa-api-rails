class AddDateOfBirthToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :date_of_birth, :Date
  end
end
