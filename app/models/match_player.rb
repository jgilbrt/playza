class MatchPlayer < ApplicationRecord
  belongs_to :match
  belongs_to :user

  # status: e.g., "confirmed", "pending", "declined"
  validates :status, inclusion: { in: %w[confirmed pending declined] }, allow_nil: true
end
