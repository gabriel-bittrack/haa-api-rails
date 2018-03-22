class CreateSlides < ActiveRecord::Migration[5.1]
  def change
    create_table :slides do |t|
      t.integer :slide_number
      t.string :slide_text
      t.integer :timeline_id
      t.timestamps
    end
  end
end
