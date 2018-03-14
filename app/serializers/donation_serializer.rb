class DonationSerializer < ActiveModel::Serializer
  attributes :id
  attribute :eighties do
    id = object.id
    {
      total_awarded: object.sum_eighties
    }
  end

  attribute :nineties do
    id = object.id
    {
      total_awarded: object.sum_nineties
    }
  end
end
