require 'csv'

class Member < ApplicationRecord
  self.per_page = 24
  scope :year, ->(class_year) { where("class_year = ?", class_year) if class_year.present? }
  scope :search_name, ->(name) { where("LOWER(full_name) LIKE LOWER(?)", "%#{name}%") if name.present? }
  scope :search_name_begins_with, -> (name) { where("last_name LIKE ?","#{name}%") if name.present? }
  scope :search_country, -> (country) { where("country = ?", country) if country.present? }
  scope :search_state, -> (state) { where("state = ?", state) if state.present? }
  scope :search_industry, -> (industry) { where("industry LIKE ?", "%#{industry}%") if industry.present? }
  scope :search_city, -> (city) { where("city = ?", city) if city.present? }
  scope :order_by_lastname, -> () { reorder(last_name: :asc)}

  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  def as_json(options={})
    super(only: [:full_name, :state, :city, :lat, :lng ], options: options)
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
          .order_by_lastname
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

  def self.sum_seventies
    seventies.count
  end

  def self.sum_eighties
    eighties.count
  end

  def self.sum_nineties
    nineties.count
  end

  def self.sum_two_thousands
    two_thousands.count
  end

  def self.sum_two_thousand_tens
    two_thousand_tens.count
  end

  def self.sum_all_time
    eighties + nineties + two_thousands + two_thousand_tens
  end

  def self.seventies
    Member.where(class_year: SEVENTIES)
  end

  def self.eighties
    Member.where(class_year: EIGHTIES)
  end

  def self.nineties
    Member.where(class_year: NINETIES)
  end

  def self.two_thousands
    Member.where(class_year: TWO_THOUSANDS)
  end

  def self.two_thousand_tens
    Member.where(class_year: TWO_THOUSAND_TENS)
  end

  private

  SEVENTIES =
    %(
      1970
      1971
      1972
      1973
      1974
      1975
      1976
      1977
      1978
      1979
    )

  EIGHTIES =
    %w(
      1980
      1981
      1982
      1983
      1984
      1985
      1986
      1987
      1988
      1989
    ).freeze

  NINETIES =
    %w(
      1990
      1991
      1992
      1993
      1994
      1995
      1996
      1997
      1998
      1999
    ).freeze

  TWO_THOUSANDS =
    %w(
      2000
      2001
      2002
      2003
      2004
      2005
      2006
      2007
      2008
      2009
    ).freeze

  TWO_THOUSAND_TENS =
    %w(
      2010
      2011
      2012
      2013
      2014
      2015
      2016
      2017
      2018
      2019
    ).freeze
end
