class MemberSerializer < ActiveModel::Serializer
  attributes :full_name, :first_name, :last_name
end
