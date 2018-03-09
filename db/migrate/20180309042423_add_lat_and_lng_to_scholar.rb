class AddLatAndLngToScholar < ActiveRecord::Migration[5.1]
  def change
    add_column :scholars, :lat, :decimal, {:precision=>10, :scale=>6}
    add_column :scholars, :lng, :decimal, {:precision=>10, :scale=>6}
  end
end
