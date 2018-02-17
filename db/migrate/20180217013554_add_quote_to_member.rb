class AddQuoteToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :quote, :string
  end
end
