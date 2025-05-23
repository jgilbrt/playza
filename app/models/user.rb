class User < ApplicationRecord
  belongs_to :team, optional: true

  has_many :match_players
  has_many :matches, through: :match_players

  has_many :awards
  has_many :payments

    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Example roles: manager, player
VALID_ROLES = ["manager", "player", "admin"]
validates :role, inclusion: { in: VALID_ROLES }

def goals_scored
    match_players.sum(:goals_scored)
  end

  def assists
    match_players.sum(:assists)
  end

  def appearances
    match_players.count
  end

  def dotd_count
    awards.where(award_type: "DOTD").count
  end

  def potm_count
    awards.where(award_type: "POTM").count
  end

  def hangover_count
    awards.where(award_type: "Hangover").count
  end

  def payment_status
    # Check if there are any payments with status 'pending' or 'owed'
    if payments.where(status: 'pending').exists? || payments.where(status: 'owed').exists?
      "Owes Money"
    else
      "Up to Date"
    end
  end

end
