class AddDateOfDeathToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :date_of_death, :date
  end
end
