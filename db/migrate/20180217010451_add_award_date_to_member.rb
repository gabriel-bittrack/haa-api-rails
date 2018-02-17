class AddAwardDateToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :award_date, :integer
  end
end
