class MatchPlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match
  before_action :set_match_player, only: [:edit, :update, :destroy]

  def index
    # Show all players for a match
    @match_players = @match.match_players.includes(:user)
  end

  def new
    @match_player = @match.match_players.new
  end

  def create
    @match_player = @match.match_players.new(match_player_params)
    if @match_player.save
      redirect_to match_match_players_path(@match), notice: 'Player added to match.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @match_player.update(match_player_params)
      redirect_to match_match_players_path(@match), notice: 'Player info updated.'
    else
      render :edit
    end
  end

  def destroy
    @match_player.destroy
    redirect_to match_match_players_path(@match), notice: 'Player removed from match.'
  end

  private

  def set_match
    @match = Match.find(params[:match_id])
  end

  def set_match_player
    @match_player = @match.match_players.find(params[:id])
  end

  def match_player_params
    params.require(:match_player).permit(:user_id, :status, :role, :goals_scored, :assists)
  end
end
