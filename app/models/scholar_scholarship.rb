class ScholarScholarship < ApplicationRecord

  def self.sum_eighties
    eighties
  end

  def self.sum_nineties
    nineties
  end

  def self.sum_two_thousands
    two_thousands
  end

  def self.sum_two_thousand_tens
    two_thousand_tens
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

  def self.eighties
    calculate_award(ScholarScholarship.where(year: EIGHTIES))
  end

  def self.nineties
    calculate_award(ScholarScholarship.where(year: NINETIES))
  end

  def self.two_thousands
    calculate_award(ScholarScholarship.where(year: TWO_THOUSANDS))
  end

  def self.two_thousand_tens
    calculate_award(ScholarScholarship.where(year: TWO_THOUSAND_TENS))
  end

  private
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
