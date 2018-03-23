class Scholar < ApplicationRecord
  self.per_page = 24
  scope :year, ->(class_year) { where("class_year = ?", class_year) if class_year.present? }
  scope :search_name, ->(name) { where("full_name LIKE ?", "%#{name}%") if name.present? }
  scope :search_name_begins_with, -> (name) { where("last_name LIKE ?","#{name}%") if name.present? }
  scope :search_country, -> (country) { where("country = ?", country) if country.present? }
  scope :search_state, -> (state) { where("state = ?", state) if state.present? }
  scope :search_city, -> (city) { where("city = ?", city) if city.present? }
  scope :search_alumni, -> (alumni) { where("alumni = ?", alumni) if alumni.present? }
  scope :limit_by_standing, -> () { where(scholar_standing: ["Good Standing", "Probation", "Special Case"]) }

  has_attached_file :profile_image, style: {
    original: ["100%", :png],
    thumb: ['100x100', :png],
    square: ['200x200#', :png],
    medium: ['300x300>', :png],
  }

  def self.distinct_studies
    studies = []
    scholars = Scholar.all 
    scholars.each do |scholar|
      
      studies << scholar.under_graduate_studies
      studies << scholar.post_graduate_studies
      studies << scholar.secondary_graduate_studies
    end
    uniq_studies = studies.uniq

    new_array = []
    uniq_studies.each do |study|
      puts "#{study}"
      ar = study.split(",") unless study == nil
      new_array << ar
    end

    ar_u = new_array.uniq
    puts "number of studies : #{ar_u.length}"

    File.open("studies", "w+") do |f|
      f.each
    end
  end

  def as_json(options={})
    super(only: [:full_name, :state, :city, :lat, :lng], methods: [])
  end

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
           .search_name_begins_with(search[:name])
           .search_state(search[:state])
           .search_alumni(search[:alumni])
           .limit_by_standing
           .page(page)
  end

  def self.map_search(search)
    Scholar.search_country(search[:country])
          .search_state(search[:state])
          .search_city(search[:city])
          .search_alumni(search[:alumni])
          .limit_by_standing
  end

  def self.map_scholarship_total(search)
    scholarships = 0

    scholars = Scholar.search_country(search[:country])
           .search_state(search[:state])
           .search_alumni(search[:alumni])

    scholars.each do |scholar|
     scholarships += scholar.total_disbursement_allotment
    end
    scholarships
  end

  def self.to_csv(fields = column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields
      all.each do |scholar|
        csv << scholar.attributes.values_at(*fields)
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

  def self.calculate_award(decade)
    total_awarded = 0
    decade.each do |scholarship|
      if scholarship && scholarship.total_award && scholarship.number_awarded
        total_awarded += scholarship.total_award * scholarship.number_awarded
      end
    end
    total_awarded
  end

  def self.seventies
    Scholar.where(class_year: SEVENTIES)
  end

  def self.eighties
    Scholar.where(class_year: EIGHTIES)
  end

  def self.nineties
    Scholar.where(class_year: NINETIES)
  end

  def self.two_thousands
    Scholar.where(class_year: TWO_THOUSANDS)
  end

  def self.two_thousand_tens
    Scholar.where(class_year: TWO_THOUSAND_TENS)
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
