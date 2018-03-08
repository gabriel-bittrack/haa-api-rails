class CollegiatePartnerProcessor < SyncProcessor
  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    # delete
    puts ">>>>> collegiate_sql_statement : #{collegiate_sql_statement}"
    process_colleges(client.query(collegiate_sql_statement))
  end

  private
  def collegiate_sql_statement
    @sql_statement ||= "select " + COLLEGE_FIELDS.join(",") + " from College_SAT_Code__c where Partner__c = true"
  end

  # def delete
  #   Colleges.delete_all
  # end

  COLLEGE_FIELDS = %w(
    ID
    CC_School__c
    Zip_Code__c
    State__c
    Country__c
    Partner__c
  )

  def process_colleges(colleges)
    colleges.each do |college|
      puts "College : #{college.inspect}"
    end
    # college = College.create(

    # )
  end
end