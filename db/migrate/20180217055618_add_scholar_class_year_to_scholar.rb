class AddScholarClassYearToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :class_year, :integer
  end
end
