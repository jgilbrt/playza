class Award < ApplicationRecord
  belongs_to :match
  belongs_to :user

  # award_type: e.g., "potm", "dotd"
end
