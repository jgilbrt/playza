class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    # Assuming user belongs to a team
    @team = current_user.team

    # Next match (upcoming)
    @next_match = @team.matches.where('date >= ?', Time.current).order(:date).first

    # Current players count
    @players_count = @team.users.count

    # Last match (most recent past match)
    @last_match = @team.matches.where('date < ?', Time.current).order(date: :desc).first

    # Awards for last match
    @last_match_awards = @last_match&.awards || []

    # Payment summary for team players (paid/unpaid count)
    @paid_count = Payment.where(user: @team.users, status: 'paid').count
    @unpaid_count = Payment.where(user: @team.users, status: 'unpaid').count

    # Overview stats (win/draw/lose, top scorer, etc) -- simplified example:
    @wins = @team.matches.where('score_own > score_opponent').count
    @draws = @team.matches.where('score_own = score_opponent').count
    @losses = @team.matches.where('score_own < score_opponent').count

    # Star player (most POTM)
    @star_player = @team.users.joins(:awards)
                      .where(awards: { award_type: 'potm' })
                      .group('users.id')
                      .order('COUNT(awards.id) DESC')
                      .first

    # Biggest dick (most DOTD)
    @biggest_dick = @team.users.joins(:awards)
                      .where(awards: { award_type: 'dotd' })
                      .group('users.id')
                      .order('COUNT(awards.id) DESC')
                      .first

    # Wall of shame (players who owe payments)
    @players_owing = @team.users.joins(:payments).where(payments: { status: 'unpaid' }).distinct
  end

def index
  team = current_user.team

  # Next upcoming match (ordered by date, future only)
  @next_match = team.matches.where("date >= ?", Date.today).order(:date).first

  # Last completed match (ordered by date, past only)
  @last_match = team.matches.where("date < ?", Date.today).order(date: :desc).first

  # Summary stats (wins, draws, losses, goals)
  @wins = team.matches.where("score_own > score_opponent").count
  @draws = team.matches.where("score_own = score_opponent").count
  @losses = team.matches.where("score_own < score_opponent").count
  @goals_scored = team.matches.sum(:score_own)

  # Player awards counts
  # Assuming Award model has award_type: "potm" (Player of the Match), "dotd" (Dick of the Day)
  @star_player = team.users.joins(:awards).where(awards: { award_type: "potm" })
                      .group('users.id').order('COUNT(awards.id) DESC').first
  @top_dick = team.users.joins(:awards).where(awards: { award_type: "dotd" })
                      .group('users.id').order('COUNT(awards.id) DESC').first

  # Top scorer by goals (sum of goals_scored in MatchPlayer)
  @top_scorer = team.users.joins(:match_players)
                      .group('users.id')
                      .order('SUM(match_players.goals_scored) DESC').first

  # Payment summary
  @paid_count = team.users.joins(:payments).where(payments: { status: "paid" }).distinct.count
  @unpaid_count = team.users.joins(:payments).where(payments: { status: "unpaid" }).distinct.count

  # Players who owe money (unpaid payments sum)
  @players_owing = team.users.joins(:payments).where(payments: { status: "unpaid" })
                      .select('users.*, SUM(payments.amount) as amount_owed')
                      .group('users.id')
                      .having('SUM(payments.amount) > 0')
end


end
