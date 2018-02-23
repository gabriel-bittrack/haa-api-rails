class AddProfileImageToScholars < ActiveRecord::Migration[5.1]
  def change
    add_attachment :scholars, :profile_image
  end
end
