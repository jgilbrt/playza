class Payment < ApplicationRecord
  belongs_to :user

  # status: e.g., "paid", "unpaid"
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[paid unpaid] }
end
