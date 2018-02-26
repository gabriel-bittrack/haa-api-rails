class FriendSerializer < ActiveModel::Serializer
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
      relationship: object.relationship
    }
  end

  attribute :organization do
    id = object.id
    {
      organization: object.current_org,
      title: object.title
    }
  end
end
