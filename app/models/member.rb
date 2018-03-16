require 'csv'

class Member < ApplicationRecord
  self.per_page = 24
  scope :year, ->(class_year) { where("class_year = ?", class_year) if class_year.present? }
  scope :search_name, ->(name) { where("full_name LIKE ?", "%#{name}%") if name.present? }
  scope :search_name_begins_with, -> (name) { where("last_name LIKE ?","#{name}%") if name.present? }
  scope :search_country, -> (country) { where("country = ?", country) if country.present? }
  scope :search_state, -> (state) { where("state = ?", state) if state.present? }
  scope :search_industry, -> (industry) { where("industry LIKE ?", "%#{industry}%") if industry.present? }
  scope :search_city, -> (city) { where("city = ?", city) if city.present? }

  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  def as_json(options={})
    super(only: [:full_name, :lat, :lng ], options: options)
  end

  validates_attachment :profile_image,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  def self.distinct_industries
    members = Member.select(:industry).distinct
    industries = []

    members.each do |member|
      unless member.industry.nil?
        member_industries = member.industry.split(";")
        member_industries.each do |industry|
          industries << industry unless industries.include? industry
        end
      end
    end

    return industries.sort!
  end

  def self.distinct_class_years
    members = Member.select(:class_year).distinct
    class_years = []

    members.each do |member|
      unless member.class_year.nil?
        class_years << member.class_year unless class_years.include? member.class_year
      end
    end

    return class_years.sort!
  end

  def self.search(search, page)
    Member.year(search[:class_year])
          .search_name_begins_with(search[:s])
          .search_name(search[:name])
          .search_state(search[:state])
          .search_industry(search[:industry])
          .page(page)
  end

  def self.map_search(search)
    Member.search_country(search[:country])
          .search_state(search[:state])
          .search_city(search[:city])
  end

  def self.to_csv(fields = column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields
      all.each do |member|
        csv << member.attributes.values_at(*fields)
      end
    end
  end
end
