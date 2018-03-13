class ScholarScholarshipProcessor < SyncProcessor
  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    delete
    process_scholarships(client.query(scholarship_sql_statement))
  end

  private
  def delete
    ScholarScholarship.delete_all
  end

  def scholarship_sql_statement
    @scholarship_sql_statement ||= "select " + SCHOLARSHIP_FIELDS.join(",") + " from 	Scholar_Scholarship__c"
  end

  def process_scholarships(scholarships)
    scholarships.each do |scholarship|
      ScholarScholarship.create(
        name: scholarship.Name,
        year: scholarship.Year_Of_Award__c,
        total_award: scholarship.Total_Award__c,
        number_awarded: scholarship.Awards_Actual__c
      )
      puts ">>> ***************************** <<<"
      puts ">>> scholarship : #{scholarship.Name}"
      puts ">>> total awards : #{scholarship.Total_Award__c}"
      puts ">>> year of award : #{scholarship.Year_Of_Award__c}"
      puts ">>> actually awarded : #{scholarship.Awards_Actual__c}"
    end
  end

  SCHOLARSHIP_FIELDS =
    %w(
      Id
      Name
      Awards_Actual__c
      Year_Of_Award__c
      Total_Award__c
    )
end
