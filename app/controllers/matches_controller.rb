class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_match, only: [:show, :edit, :update, :destroy, :lineup, :set_lineup, :set_awards, :scorers, :assign_dotd, :dick_of_the_day]

  # Calculate season string based on date
  def calculate_season(date)
    if date.month < 6
      start_year = date.year - 1
    else
      start_year = date.year
    end
    "#{start_year}/#{start_year + 1}"
  end

  # List all matches grouped by season (latest season first)
  def index
    @team_players = @team.players
    all_matches = @team.matches.order(:date)
    grouped = all_matches.group_by { |m| calculate_season(m.date) }

    sorted_seasons = grouped.keys.sort_by { |s| s.split("/").first.to_i }.reverse
    cs = current_season
    if sorted_seasons.include?(cs)
      sorted_seasons.delete(cs)
    end
    sorted_seasons.unshift(cs)

    @matches_by_season = {}

    sorted_seasons.each do |season|
      matches = grouped[season] || []
      future_matches = matches.select { |m| !m.has_happened? }
      past_matches = matches.select { |m| m.has_happened? }
      @matches_by_season[season] = {
        future: future_matches,
        past: past_matches
      }
    end
  end

  # Show details for one match, including lineup and awards
  def show
    @team_players = @match.team.players
    @lineup_starters = @match.lineup_starters || []
    @lineup_substitutes = @match.lineup_substitutes || []
    @spin_wheel_items = ["wear a tutu", "buy the beers", "sing a song"]
  end

  # Form to create a new match
  def new
    @match = @team.matches.new
  end

  # Create the match and set season automatically
  def create
    @match = @team.matches.new(match_params)
    @match.season = calculate_season(@match.date)

    if @match.save
      if params[:match][:has_happened] == "1"
        save_scorers(@match, params[:match][:scorers])
      end
      redirect_to matches_path, notice: "Match created!"
    else
      redirect_to matches_path, alert: "Failed to create match. Please try again."
    end
  end

  def edit; end

  # Update match with submitted data
  def update
    if @match.update(match_params)
      redirect_to @match, notice: "Match updated!"
    else
      render :edit
    end
  end

  # Delete a match
  def destroy
    @match.destroy
    redirect_to matches_path, notice: "Match deleted."
  end

  # Show or edit the lineup for this match
  def lineup
    starters = params.dig(:lineup, :starters) || []
    substitutes = params.dig(:lineup, :substitutes) || []

    starters.map!(&:to_i)
    substitutes.map!(&:to_i)

    @match.update(lineup_starters: starters, lineup_substitutes: substitutes)

    redirect_to match_path(@match), notice: "Lineup saved successfully."
  end

  # Save lineup changes from form input
  def set_lineup
    params[:match_players]&.each do |user_id, attributes|
      mp = @match.match_players.find_or_initialize_by(user_id: user_id)
      mp.update(attributes.permit(:status, :role))
    end
    redirect_to lineup_match_path(@match), notice: "Lineup saved!"
  end

  # Assign awards like Player of the Match (potm) or Dick of the Day (dotd)
  def set_awards
    Award.where(match: @match).destroy_all

    %w[potm dotd].each do |award_type|
      user_id = params[award_type]
      if user_id.present?
        Award.create!(match: @match, user_id: user_id, award_type: award_type)
      end
    end

    redirect_to match_path(@match), notice: "Awards assigned!"
  end

  def end_season
    redirect_to matches_path, notice: "Season ended!"
  end

  def start_new_season
    current_year = Date.today.year
    new_season = "#{current_year}/#{current_year + 1}"
    session[:current_season] = new_season
    redirect_to matches_path, notice: "New season #{new_season} started!"
  end

  def current_season
    today = Date.today
    if today.month < 6
      "#{today.year - 1}/#{today.year}"
    else
      "#{today.year}/#{today.year + 1}"
    end
  end

  def scorers
    # handle scorers logic
  end

  def assign_dotd
    @player = Player.find(params[:player_id])
    @match.update(dick_of_the_day_player_id: @player.id)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to match_path(@match), notice: "Dick of the Day set to #{@player.name}!" }
    end
  end

  def dick_of_the_day
    dotd_params = params.require(:dick).permit(:player_id, :item)
    @match.update(
      dick_of_the_day_player_id: dotd_params[:player_id],
      dotd_punishment: dotd_params[:item]
    )

    if @match.save
      redirect_to @match, notice: "Dick of the Day saved!"
    else
      flash.now[:alert] = "Failed to save."
      render :show
    end
  end

  private

  def match_params
    params.require(:match).permit(:has_happened, :opponent_name, :date, :location, :score_own, :score_opponent)
  end

  def set_team
    @team = current_user.team
  end

  def set_match
    @match = @team.matches.find(params[:id])
  end
end
