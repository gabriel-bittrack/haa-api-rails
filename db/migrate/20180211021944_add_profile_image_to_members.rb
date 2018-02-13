class AddProfileImageToMembers < ActiveRecord::Migration[5.1]
  def change
    add_attachment :members, :profile_image
  end
end
