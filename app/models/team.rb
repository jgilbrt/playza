class Team < ApplicationRecord
  has_many :users
  has_many :matches
  has_many :payments

has_many :players, -> { where(role: 'player') }, class_name: 'User'

 has_one_attached :avatar
  validates :name, presence: true

  def new_team?
    matches.count == 0
  end
end
