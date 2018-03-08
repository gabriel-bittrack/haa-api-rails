class FriendSerializer < ActiveModel::Serializer
  attributes :full_name, :first_name, :last_name
  attribute :address do
    id = object.id
    {
      city: object.city,
      state: object.state,
      country: object.country
    }
  end

  attribute :organization do
    id = object.id
    {
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
      photo: url
    }
  end
end
