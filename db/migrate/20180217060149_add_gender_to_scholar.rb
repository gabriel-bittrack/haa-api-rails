class AddGenderToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :gender, :text
  end
end
