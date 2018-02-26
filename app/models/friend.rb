class Friend < ApplicationRecord
  create_table :friends do |t|
    t.string :full_name
    t.string :first_name
    t.string :last_name
    t.string :city
    t.string :state
    t.string :country
    t.string :title
    t.string :current_org
  end
end
