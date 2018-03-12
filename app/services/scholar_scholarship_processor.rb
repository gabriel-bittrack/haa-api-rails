class ScholarScholarshipProcessor < SyncProcessor
  def initialize(current_user)
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
    @scholarship_sql_statement ||= "select " + SCHOLARSHIP_FIELDS.join(",") + " from 	Scholar_Scholarship_Award__c"
  end

  def process_scholarships(scholarships)
    scholarships.each do |scholarship|
      puts ">>> scholarship : #{scholarship.name}"
    end
  end

  SCHOLARSHIP_FIELDS =
    %w(
      Id
      Name

    )
end
