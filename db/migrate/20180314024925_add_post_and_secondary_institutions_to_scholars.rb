class AddPostAndSecondaryInstitutionsToScholars < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :post_graduate_institution, :string
    add_column :scholars, :secondary_graduate_institution, :string
  end
end
