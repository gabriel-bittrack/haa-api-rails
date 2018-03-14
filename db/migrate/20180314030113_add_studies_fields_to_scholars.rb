class AddStudiesFieldsToScholars < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :under_graduate_studies, :string
    add_column :scholars, :post_graduate_studies, :string
    add_column :scholars, :secondary_graduate_studies, :string
  end
end
