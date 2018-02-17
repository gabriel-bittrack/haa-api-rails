class AddSfidToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :sf_id, :string
  end
end
