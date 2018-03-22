class AddTitleToSlide < ActiveRecord::Migration[5.1]
  def change
    add_column :slides, :title, :string
  end
end
