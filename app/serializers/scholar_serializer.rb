class ScholarSerializer < ActiveModel::Serializer

  attributes :full_name, :first_name, :last_name, :scholar_standing
  attribute :address do
    id = object.id
    {
      city: object.city,
      state: object.state,
      country: object.country,
      lat: object.lat,
      lng: object.lng
    }
  end

  attribute :demographic do
    id = object.id
    {
      ethnicity: object.ethnicity,
      gender: object.gender
    }
  end

  attribute :alumni_information do
    id = object.id

    base = ENV.fetch("S3_BASE")
    bucket = ENV.fetch("S3_BUCKET_NAME")

    url = ''
    if object.profile_image.path
      url = base + bucket + object.profile_image.path
    end

    {
      photo: url,
      alumni: object.alumni,
      specialized_scholar: object.specialized_scholar,
      military_scholar: object.military_scholar,
      scholar_standing: object.scholar_standing,
      total_disbursement_allotment: object.total_disbursement_allotment,
      military_branch: object.military_branch,
      scholar_class_year: object.class_year,
      date_of_birth: object.date_of_birth
    }
  end

  attribute :school_information do
    id = object.id
    {
      high_school: object.high_school,
      undergraduate_institution: object.undergraduate_institution,
      post_graduate_institution: object.post_graduate_institution,
      secondary_graduate_institution: object.secondary_graduate_institution,
      under_graduate_studies: object.under_graduate_studies,
      post_graduate_studies: object.post_graduate_studies,
      secondary_graduate_studies: object.secondary_graduate_studies,
    }
  end
end
