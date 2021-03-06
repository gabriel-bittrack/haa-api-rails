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
        high_school: scholar.High_School_Label__c,
        state: scholar.PPA_State__c,
        city: scholar.PPA_City__c,
        scholar_standing: scholar.Scholar_Standing__c,
        country: scholar.PPA_Country__c,
        scholar: scholar.Association_Scholar__c,
        alumni: scholar.Association_Alumni__c,
        specialized_scholar: scholar.Association_Military_Scholar__c,
        undergraduate_institution: scholar.Undergraduate_Studies_Institution__c,
        undergraduate_degree: scholar.Undergraduate_Studies_Major__c,
        total_disbursement_allotment: scholar.Total_Disbursement_Allotment__c,
        class_year: scholar.Scholar_Class_Year__c,
        ethnicity: scholar.haa_Race__c,
        gender: scholar.Gender__c,
        date_of_birth: scholar.Date_of_Birth__c,
        post_graduate_institution: scholar.PostGraduate_Studies_Institution__c,
        secondary_graduate_institution: scholar.Secondary_Graduate_Institution__c,
        under_graduate_studies: scholar.Graduate_Major_Category__c,
        post_graduate_studies: scholar.Scholar_Major_Category__c,
        secondary_graduate_studies: scholar.Scholar_Major_Category__c
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
      High_School_Label__c
      PPA_State__c
      PPA_City__c
      PPA_Country__c
      Association_Scholar__c
      Association_Alumni__c
      Association_Specialized_Scholar__c
      Association_Military_Scholar__c
      toLabel(Scholar_Standing__c)
      Military_Service_Military_Branch__c
      Undergraduate_Studies_Institution__c
      PostGraduate_Studies_Institution__c
      Secondary_Graduate_Institution__c
      Undergraduate_Studies_Major__c
      Graduate_Major_Category__c
      toLabel(Scholar_Major_Category__c)
      PostGraduate_Studies_Major__c
      toLabel(Secondary_Graduate_Major_Category__c)
      Total_Disbursement_Allotment__c
      Scholar_Class_Year__c
      toLabel(haa_Race__c)
      toLabel(Gender__c)
      Date_of_Birth__c
    )
end
