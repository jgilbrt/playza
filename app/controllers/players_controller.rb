class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
before_action :set_player, only: [:show]

  def index
    @players = @team.users.order(:email) # or any order you want
    @users = User.all
  end

  def show
    # Player stats and payment history
    @payments = @player.payments.order(created_at: :desc)

    # Aggregated stats from matches
    @appearances = @player.match_players.count
    @goals_scored = @player.match_players.sum(:goals_scored)
    @assists = @player.match_players.sum(:assists)

    # Awards counts
    @dotd_count = @player.awards.where(award_type: 'dotd').count
    @potm_count = @player.awards.where(award_type: 'potm').count

    # Custom field - hangover_count (if you have it somewhere, otherwise skip)
    # @hangover_count = @player.hangovers.count or similar if modeled

  end

  def notify
    # Custom action where manager can send a notification message to player
    # You can implement email or in-app notification here
    message = params[:message]
    # For now just a flash message demo
    # In reality, you'd call mailer or notification service
    if message.present?
      # Example: PlayerMailer.notify(@player, message).deliver_later
      flash[:notice] = "Notification sent to #{@player.email}"
    else
      flash[:alert] = "Please enter a message"
    end
    redirect_to player_path(@player)
  end

  private

  def set_team
    @team = current_user.team
  end

  def set_player
    @player = @team.users.find(params[:id])
  end
end
