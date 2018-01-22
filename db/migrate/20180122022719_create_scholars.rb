class CreateScholars < ActiveRecord::Migration[5.1]
  def change
    create_table :scholars do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :high_school
      t.string :state
      t.string :city
      t.string :country
      t.boolean :scholar
      t.boolean :alumni
      t.boolean :specialized_scholar
      t.boolean :alumni
      t.boolean :military_scholar
      t.string :scholar_standing
      t.string :military_branch
      t.string :undergraduate_institution
      t.string :undergraduate_degree
      t.string :undergraduate_major
      t.timestamps
    end
  end
end
