class AddEthnicityToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :ethnicity, :string
  end
end
