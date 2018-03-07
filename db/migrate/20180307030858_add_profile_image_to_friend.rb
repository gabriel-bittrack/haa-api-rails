class AddProfileImageToFriend < ActiveRecord::Migration[5.1]
  def change
    add_attachment :friends, :profile_image
  end
end
