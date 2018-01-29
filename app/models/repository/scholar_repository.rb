module Repository
  class ScholarRepository
    def self.count
      Scholar.all.count
    end

    def self.total_scholarships_given
      85
    end
  end
end
