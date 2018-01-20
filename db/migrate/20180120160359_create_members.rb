class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
