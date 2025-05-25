class User < ApplicationRecord
  scope :players, -> { where(role: 'player') }
  belongs_to :team, optional: true

  has_many :match_players
  has_many :matches, through: :match_players
  has_one_attached :avatar
  has_many :awards
  has_many :payments

  accepts_nested_attributes_for :team


    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Example roles: manager, player
VALID_ROLES = ["manager", "player", "admin"]
validates :role, inclusion: { in: VALID_ROLES }

def goals_scored
    match_players.sum(:goals_scored)
  end

   def amount_owed
    # Sum of unpaid payments amounts for this user
    payments.where(status: 'unpaid').sum(:amount)
  end

  def assists
    match_players.sum(:assists)
  end

  # app/models/user.rb
def full_name
  "#{first_name} #{last_name}".strip
end


def appearances
  match_players.where(status: "confirmed").count
end

  def dotd_count
awards.where("LOWER(award_type) = ?", "dotd").count
  end

  def potm_count
awards.where("LOWER(award_type) = ?", "potm").count
  end

  def hangover_count
awards.where("LOWER(award_type) = ?", "hangover").count
  end

def payment_status
  if payments.where(status: 'unpaid').exists?
    "Owes Money"
  else
    "Up to Date"
  end
end

  def name
    email
  end

end
