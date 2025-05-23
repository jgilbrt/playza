class Award < ApplicationRecord
  belongs_to :match
  belongs_to :user

  # award_type: e.g., "potm", "dotd"
  validates :award_type, presence: true, inclusion: { in: %w[potm dotd] }
end
