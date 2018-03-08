class Scholar < ApplicationRecord
  self.per_page = 24
  scope :year, ->(class_year) { where("class_year = ?", class_year) if class_year.present? }
  scope :search_name, ->(name) { where("full_name LIKE ?", "%#{name}%") if name.present? }
  scope :search_state, -> (state) { where("state = ?", state) if state.present? }
  scope :search_alumni, -> (alumni) { where("alumni = ?", alumni) if alumni.present? }

  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  validates_attachment :profile_image,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  def self.distinct_class_years
    scholars = Scholar.select(:class_year).distinct
    class_years = []

    scholars.each do |scholar|
      unless scholar.class_year.nil?
        if scholar.class_year > 1
          class_years << scholar.class_year unless class_years.include? scholar.class_year
        end
      end
    end

    return class_years.sort!
  end

  def self.search(search, page)
    Scholar.year(search[:class_year])
           .search_name(search[:s])
           .search_state(search[:state])
           .search_alumni(search[:alumni])
           .page(page)
  end

  def self.to_csv(fields = column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields
      all.each do |scholar|
        csv << scholar.attributes.values_at(*fields)
      end
    end
  end
end
