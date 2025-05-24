class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_match, only: [:show, :edit, :update, :destroy, :lineup, :set_lineup, :set_awards]

  # Calculate season string based on date
def calculate_season(date)
  # If date before June, season started previous year
  if date.month < 6
    start_year = date.year - 1
  else
    start_year = date.year
  end
  "#{start_year}/#{start_year + 1}"
end
  # List all matches grouped by season (latest season first)
def index
     @team_players = current_user.team.players

  all_matches = Match.all.order(:date)
  grouped = all_matches.group_by { |m| calculate_season(m.date) }

  # Sort seasons by start year descending
  sorted_seasons = grouped.keys.sort_by { |s| s.split("/").first.to_i }.reverse

  # Ensure current season is at top
  cs = current_season
  if sorted_seasons.include?(cs)
    sorted_seasons.delete(cs)
  end
  sorted_seasons.unshift(cs)

  @matches_by_season = {}

  sorted_seasons.each do |season|
    matches = grouped[season] || []

    future_matches = matches.select { |m| m.date && m.date >= Date.today }
    past_matches = matches.select { |m| m.date && m.date < Date.today }

    @matches_by_season[season] = {
      future: future_matches,
      past: past_matches
    }
  end
end
  # Show details for one match, including lineup and awards
def show
  @match = Match.find(params[:id])

  # Assuming the match belongs_to a team, and the team has many players
  @team_players = @match.team.players

  # Optional: if you want to handle lineup starters saved as IDs array
@lineup_starters = @match.lineup_starters || []
  @lineup_substitutes = @match.lineup_substitutes || []
  @spin_wheel_items = ["wear a tutu", "buy the beers", "sing a song"]

end

  # Form to create a new match
  def new
    @match = @team.matches.new
    @players = current_user.team.users
  end

  # Create the match and set season automatically
  def create
    @match = current_user.team.matches.new(match_params)
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

  # Edit form (just renders the edit view)
  def edit
  end

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
  @match = Match.find(params[:id])
  starters = params.dig(:lineup, :starters) || []
  substitutes = params.dig(:lineup, :substitutes) || []

  # Convert to integers (from strings)
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
    # Remove previous awards for this match
    Award.where(match: @match).destroy_all

    %w[potm dotd].each do |award_type|
      user_id = params[award_type]
      if user_id.present?
        Award.create!(match: @match, user_id: user_id, award_type: award_type)
      end
    end

    redirect_to match_path(@match), notice: "Awards assigned!"
  end

  # End the current season (example placeholder)
  def end_season
    # Your logic to finalize the season goes here

    redirect_to matches_path, notice: "Season ended!"
  end

  # Start a new season (example placeholder)
  def start_new_season
    current_year = Date.today.year
    new_season = "#{current_year}/#{current_year + 1}"

    # Save the new season somewhere — here using session as example
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

def lineup
    @match = Match.find(params[:id])
    # Handle lineup submission here, e.g.:
    # - Update starters and subs for the match
    # - Save to DB
    # Redirect or render as needed
  end

   def scorers
    @match = Match.find(params[:id])
    # handle scorers logic
  end


  def dick_of_the_day
  @match = Match.find(params[:id])

  @match.dick_of_the_day_player_id = params[:player_id]
  @match.dotd_punishment = params[:punishment]

  if @match.save
    redirect_to @match, notice: "Dick of the Day assigned!"
  else
    redirect_to @match, alert: "Something went wrong."
  end
end


  private

  # Strong params for matches
  def match_params
    params.require(:match).permit(:has_happened, :opponent_name, :date, :location, :score_own, :score_opponent)
  end

  # Set the team from the current user
  def set_team
    @team = current_user.team
  end

  # Find the match within the team by ID
  def set_match
    @match = @team.matches.find(params[:id])
  end
end
