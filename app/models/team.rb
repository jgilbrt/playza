class Team < ApplicationRecord
  has_many :users
  has_many :matches

  validates :name, presence: true
end
