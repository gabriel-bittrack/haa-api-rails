class CreateApiUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :api_users do |t|
      t.string :name
      t.string :token
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    add_index :api_users, :token
    add_foreign_key(
      :oauth_access_tokens,
      :api_users,
      column: :resource_owner_id
    )
  end
end
