class MatchPlayer < ApplicationRecord
  belongs_to :match
  belongs_to :user
  belongs_to :team

  # status: e.g., "confirmed", "pending", "declined"
end
