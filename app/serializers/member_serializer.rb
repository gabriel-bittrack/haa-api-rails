class MemberSerializer < ActiveModel::Serializer
  attributes :full_name, :first_name, :last_name
  attribute :address do
    id = object.id
    {
      city: object.city,
      state: object.state,
      province: object.province,
      country: object.country
    }
  end

  attribute :demographic do
    id = object.id
    {
      ethnicity: object.ethnicity,
      gender: object.gender,
      relationship: object.relationship
    }
  end

  attribute :organization do
    id = object.id
    {
      industry: object.industry,
      organization: object.current_org,
      title: object.title
    }
  end

  attribute :information do
    id = object.id
    base = ENV.fetch("S3_BASE")
    bucket = ENV.fetch("S3_BUCKET_NAME")
    
    url = ''
    if object.profile_image.path
      url = base + bucket + object.profile_image.path
    end

    {
      photo: url,
      bio: object.short_bio,
      military_branch: object.military_branch,
      video: object.web_url,
      class_year: object.class_year,
      undergraduate_institution: object.undergraduate_institution,
      graduate_institution: object.graduate_institution
    }
  end
end
