class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_match, only: [:show, :edit, :update, :destroy, :lineup, :set_lineup, :set_awards]

  def index
    @matches = @team.matches.order(date: :desc)
      @matches_by_season = Match.order(date: :desc).group_by(&:season)

  end

  def show
    # Show match details including lineup and awards
    @match_players = @match.match_players.includes(:user)
    @awards = @match.awards.includes(:user)
  end

  def new
    @match = @team.matches.new
  end

  def create
    @match = @team.matches.new(match_params)
    if @match.save
      redirect_to @match, notice: "Match created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @match.update(match_params)
      redirect_to @match, notice: "Match updated!"
    else
      render :edit
    end
  end

  def destroy
    @match.destroy
    redirect_to matches_path, notice: "Match deleted."
  end

  # Custom routes:

  def lineup
    # Show or edit lineup for the match
    @players = @team.users
    @match_players = @match.match_players.includes(:user)
  end

  def set_lineup
    # Expecting params to contain player lineup data, e.g. roles/status
    params[:match_players]&.each do |user_id, attributes|
      mp = @match.match_players.find_or_initialize_by(user_id: user_id)
      mp.update(attributes.permit(:status, :role))
    end
    redirect_to lineup_match_path(@match), notice: "Lineup saved!"
  end

  def set_awards
    # Expecting params for awards e.g. { potm: user_id, dotd: user_id }
    Award.where(match: @match).destroy_all # clear old awards first

    %w[potm dotd].each do |award_type|
      user_id = params[award_type]
      if user_id.present?
        Award.create!(match: @match, user_id: user_id, award_type: award_type)
      end
    end
    redirect_to match_path(@match), notice: "Awards assigned!"
  end

  def end_season
  # Logic to finalize the current season if needed

  # Redirect or set flash notice
  redirect_to matches_path, notice: "Season ended!"
end

def start_new_season
  # Example: set a new season string (could be stored somewhere else, e.g. in a Season model or app config)
  new_season = "2025/2026"

  # Optionally update matches or just remember the current season for new matches
  session[:current_season] = new_season

  redirect_to matches_path, notice: "New season #{new_season} started!"
end


  private

  def set_team
    @team = current_user.team
  end

end
