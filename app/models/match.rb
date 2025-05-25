class Match < ApplicationRecord
  belongs_to :team

  has_many :match_players
  has_many :users, through: :match_players
    has_many :scorers, through: :match_players, source: :user
 belongs_to :dick_of_the_day_player, class_name: 'User', optional: true

  has_many :awards

serialize :lineup_starters, JSON
serialize :lineup_substitutes, JSON

  validates :opponent_name, :date, presence: true


def current_season
  session[:current_season] || "2024/2025"
end

def has_happened?
  # match time plus 90 minutes
  match_end_time = self.date + 90.minutes
  Time.current >= match_end_time
end

  def self.group_by_season
    all.group_by(&:season)  # group matches by their `season` attribute
  end

def result
    return "No result" if score_own.nil? || score_opponent.nil?

    if score_own > score_opponent
      "Won"
    elsif score_own < score_opponent
      "Lost"
    else
      "Draw"
    end
  end
end
