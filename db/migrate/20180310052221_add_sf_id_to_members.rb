class AddSfIdToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :sf_id, :string
  end
end
