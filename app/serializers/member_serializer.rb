class MemberSerializer < ActiveModel::Serializer
  attributes :full_name, :first_name, :last_name
  attribute :address do
    id = object.id
    {
      city: object.city,
      state: object.state,
      province: object.province,
      country: object.country,
      lat: object.lat,
      lng: object.lng
    }
  end

  attribute :demographic do
    id = object.id
    deceased = object.date_of_death.present?

    {
      ethnicity: object.ethnicity,
      gender: object.gender,
      relationship: object.relationship,
      date_of_birth: object.date_of_birth,
      date_of_death: object.date_of_death,
      deceased: deceased
    }
  end

  attribute :organization do
    id = object.id
    updated_industry = ''
    updated_industry = object.industry.gsub(";",",") if object.industry
    {
      industry: updated_industry,
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
      short_bio: object.short_bio,
      quote: object.quote,
      bio: object.bio,
      military_branch: object.military_branch,
      video: object.web_url,
      class_year: object.class_year,
      award_date: object.award_date,
      undergraduate_institution: object.undergraduate_institution,
      graduate_institution: object.graduate_institution
    }
  end
end
