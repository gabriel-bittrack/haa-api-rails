class ScholarProcessor < SyncProcessor

  def initialize(current_user:)
    @current_user = current_user
  end

  def process
    delete
    process_scholars(client.query(scholar_sql_statement))
  end

  private
  def scholar_sql_statement
    @scholar_sql_statement ||= "select " + SCHOLAR_FIELDS.join(",") + " from Contact where RecordType.Name IN ('Scholar')"
  end

  def delete
    Scholar.delete_all
  end

  def process_scholars(scholars)
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
        total_disbursement_allotment: scholar.Total_Disbursement_Allotment__c,
        class_year: scholar.Scholar_Class_Year__c,
        ethnicity: scholar.haa_Race__c,
        gender: scholar.Gender__c
      }

    end
    current_user_hash = { oauth_token: @current_user.oauth_token, refresh_token: @current_user.refresh_token, instance_url: @current_user.instance_url }
    ScholarImporterWorker.perform_async(current_user_hash, scholars_array)
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
      Scholar_Class_Year__c
      toLabel(haa_Race__c)
      toLabel(Gender__c)
    )
end
