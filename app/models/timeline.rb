class Timeline < ApplicationRecord
  has_many :slides, dependent: :destroy
end
