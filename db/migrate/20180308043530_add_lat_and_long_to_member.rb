class AddLatAndLongToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :lat, :decimal, {:precision=>10, :scale=>6}
    add_column :members, :lng, :decimal, {:precision=>10, :scale=>6}
  end
end
