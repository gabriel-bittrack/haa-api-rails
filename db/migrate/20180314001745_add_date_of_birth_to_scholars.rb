class AddDateOfBirthToScholars < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :date_of_birth, :Date
  end
end
