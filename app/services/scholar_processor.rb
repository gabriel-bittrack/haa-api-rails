class ScholarProcessor < SyncProcessor

  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    delete
    process_scholars(client.query(scholar_sql_statement))

    Scholar.find_each do |scholar|
      attachments = client.query(scholar_image_attachment(scholar.sf_id))
      puts ">>>> attachments: #{attachments}"
    end
  end

  private
  def scholar_sql_statement
    @scholar_sql_statement ||= "select " + SCHOLAR_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Scholar') LIMIT 10"
  end

  def delete
    Scholar.delete_all
  end

  def process_scholars(scholars)
    scholar_ids = []
    scholars_array = []
    scholars.each do |scholar|
      scholars_array << {  
        sf_id: scholar.Id,
        full_name: scholar.Name,
        first_name: scholar.FirstName,
        last_name: scholar.LastName,
        high_school: scholar.High_School__c,
        state: scholar.PPA_State__c,
        city: scholar.PPA_City__c,
        country: scholar.PPA_Country__c,
        scholar: scholar.Association_Scholar__c,
        alumni: scholar.Association_Alumni__c,
        specialized_scholar: scholar.Association_Military_Scholar__c,
        undergraduate_institution: scholar.Undergraduate_Studies_Institution__c,
        undergraduate_degree: scholar.Undergraduate_Studies_Major__c,
        total_disbursement_allotment: scholar.Total_Disbursement_Allotment__c
      }
    end
    ScholarImporterWorker.perform_async(@current_user, scholars_array)
  end

  SCHOLAR_FIELDS =
    %w(
      Id
      Name
      FirstName
      LastName
      High_School__c
      PPA_State__c
      PPA_City__c
      PPA_Country__c
      Association_Scholar__c
      Association_Alumni__c
      Association_Specialized_Scholar__c
      Association_Military_Scholar__c
      Scholar_Standing__c
      Military_Service_Military_Branch__c
      Undergraduate_Studies_Institution__c
      Undergraduate_Studies_Major__c
      Total_Disbursement_Allotment__c
    )
end