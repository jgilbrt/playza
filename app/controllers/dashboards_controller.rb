class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = current_user.team
    unless @team
      flash[:alert] = "You are not assigned to a team yet."
      redirect_to root_path and return
    end

    # Most recent past matches
    @last_match = @team.matches
                      .where("date <= ?", Time.current)
                      .order(date: :desc)
                      .first

@dotd_player = @last_match&.dick_of_the_day_player
@dotd_punishment = @last_match&.dotd_punishment

    @second_last_match = @team.matches
                              .where("date < ?", Time.current)
                              .order(date: :desc)
                              .offset(1)
                              .first

    # Next upcoming match
    @next_match = @team.matches
                       .where("date > ?", Time.current)
                       .order(:date)
                       .first

    # Payment summary counts
    @paid_count = @team.users.joins(:payments)
                          .where(payments: { status: 'paid' })
                          .distinct
                          .count

    @unpaid_count = @team.users.joins(:payments)
                            .where(payments: { status: 'unpaid' })
                            .distinct
                            .count

    # Match results summary
    @wins = @team.matches.where('score_own > score_opponent').count
    @draws = @team.matches.where('score_own = score_opponent').count
    @losses = @team.matches.where('score_own < score_opponent').count

    # Goals scored by team
    @goals_scored = @team.matches.sum(:score_own)

    # Star player (most POTM awards)
    @star_player = @team.users.joins(:awards)
                          .where(awards: { award_type: 'potm' })
                          .group('users.id')
                          .order('COUNT(awards.id) DESC')
                          .first

    # Top scorer by goals (via match_players)
    @top_scorer = @team.users.joins(:match_players)
                         .group('users.id')
                         .order('SUM(match_players.goals_scored) DESC')
                         .first

    # Biggest dick (most DOTD awards)
    @top_dick = @team.users.joins(:awards)
                        .where(awards: { award_type: 'dotd' })
                        .group('users.id')
                        .order('COUNT(awards.id) DESC')
                        .first

    # Players owing payments
@players_owing = @team.users.select { |user| user.amount_owed.to_f > 0 }

    # Additional: details for last match
    if @last_match
      @last_match_awards = @last_match.awards.reload

      @potm_award = @last_match_awards.find_by(award_type: 'potm')
      @dotd_award = @last_match_awards.find_by(award_type: 'dotd')

      own_score = @last_match.score_own || "-"
      opp_score = @last_match.score_opponent || "-"
      @last_match_score_line = "#{own_score} - #{opp_score}"
    end
  end
end
