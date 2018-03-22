class TimeLineSeed
  def self.seed
    Timeline.delete_all
    Slide.delete_all
    self.create_timelines
    # SLIDES.each do |slide|
    #   puts ">>>> slide: #{slide}"
    # end
  end

  private
  def self.create_timelines
    puts ">>>> create_timelines"
    TIME_LINES.each do |time|
      timeline = Timeline.create(decade: time)
      puts ">>>> time : #{time}"
      puts ">>>> slides : #{SLIDES.fetch(time)}"
    end
  end

  # SLIDES =
  # {
  #   "1940": 
  #     [
  #       { slide_text: "Kenneth Beebe creates the Horatio Alger Awards Committee of the American Schools and Colleges Association. He aligns the awards with author Horatio Alger, Jr., whose books embodied the distinctly American “rags to riches” story." },
  #       { slide_text: "On July 9, 1947, the first Horatio Alger Awards are presented to four successful businessmen at Beebe’s offices in Rockefeller Center in New York City."}
  #     ]
  #   ,
  #   "1950": 
  #     [
  #       { slide_text: "The Horatio Alger Award is presented to Norman Vincent Peale on April 22, 1952. Peale is eventually considered a co-founder of the Horatio Alger Association because he is responsible for ensuring the perpetuation of Beebe’s vision for the organization." }
  #     ]
  #   ,
  #   "1970": 
  #     [
  #       { slide_text: "Cecil Earle Baker serves as President of the Horatio Alger Awards Committee, Inc., after the passing of founder Kenneth Beebe in March 1970."},
  #       { slide_text: "The first true membership meeting takes place on May 6, 1970, with Norman Vincent Peale (’52) as moderator."},
  #       { slide_text: "The Association adopts the current Horatio Alger Award selection process, whereby previous award recipients select new recipients, rather than by balloting students and professors at colleges and universities across the country."}
  #     ]
  # }

  SLIDES = [
    { "1940": 
      [{ slide_text: "Kenneth Beebe creates the Horatio Alger Awards Committee of the American Schools and Colleges Association. He aligns the awards with author Horatio Alger, Jr., whose books embodied the distinctly American “rags to riches” story." },
      { slide_text: "On July 9, 1947, the first Horatio Alger Awards are presented to four successful businessmen at Beebe’s offices in Rockefeller Center in New York City."}]
    },
    { "1950":
      [{ slide_text: "The Horatio Alger Award is presented to Norman Vincent Peale on April 22, 1952. Peale is eventually considered a co-founder of the Horatio Alger Association because he is responsible for ensuring the perpetuation of Beebe’s vision for the organization."}]
    },
    { "1970":
      [{ slide_text: "Cecil Earle Baker serves as President of the Horatio Alger Awards Committee, Inc., after the passing of founder Kenneth Beebe in March 1970."},
       { slide_text: "The first true membership meeting takes place on May 6, 1970, with Norman Vincent Peale (’52) as moderator."},
       { slide_text: "The Association adopts the current Horatio Alger Award selection process, whereby previous award recipients select new recipients, rather than by balloting students and professors at colleges and universities across the country."}]
    }
  ]
  
  TIME_LINES = %w(
    1940
    1950
    1970
    1980
    1990
    2000
    2010
  )
end