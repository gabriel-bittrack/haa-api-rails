class Friend < ApplicationRecord
  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  validates_attachment :profile_image,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  def self.to_csv(fields = column_names, options = {})
  CSV.generate(options) do |csv|
    csv << fields
    all.each do |friend|
      csv << friend.attributes.values_at(*fields)
    end
  end
end
end
