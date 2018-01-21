class AlterMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :gender, :string
    add_column :members, :relationship, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :province, :string
    add_column :members, :country, :string
    add_column :members, :class_year, :string
    add_column :members, :industry, :string
    add_column :members, :current_org, :string
    add_column :members, :ethnicity, :string
    add_column :members, :military_branch, :string
    add_column :members, :short_bio, :string
    add_column :members, :web_url, :string
    add_column :members, :undergraduate_institution, :string
    add_column :members, :graduate_institution, :string
    add_column :members, :profile_photo_url, :string
  end
end
