class Match < ApplicationRecord
  belongs_to :team

  has_many :match_players
  has_many :users, through: :match_players

  has_many :awards

  validates :opponent_name, :date, presence: true


def current_season
  session[:current_season] || "2024/2025"
end

end
