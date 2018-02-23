class Scholar < ApplicationRecord
  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  validates_attachment :profile_image,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }
end
