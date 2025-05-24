class PlayersController < ApplicationController
  before_action :authenticate_user!
before_action :set_team, only: [:index, :new, :create]
before_action :set_player, only: [:show]

def index
  if current_user.team
    @players = current_user.team.users.where(role: 'player')
    @payments = Payment.where(user: current_user.team.users).includes(:user)
  else
    @players = []
    @payments = []
  end
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

def add
  user = User.find_by(email: params[:email])

  if user && user.role == "player"
    user.update(team: current_user.team)
    flash[:notice] = "#{user.email} added to your team!"
  else
    flash[:alert] = "User not found or not a player"
  end

  redirect_to players_path
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

def new
  @player = Player.new
  @users = User.all  # Or fetch users with some search logic if needed
end



  def create
    @player = @team.users.build(player_params)
    @player.role = "player"

    if @player.save
      redirect_to team_players_path(@team), notice: "Player added!"
    else
      render :new
    end
  end

  private

def set_team
  @team = Team.find(params[:team_id]) if params[:team_id]
end

  def set_player
    @player = @team.users.find(params[:id])
  end

    def player_params
params.require(:user).permit(:email, :password, :password_confirmation, :name, :position, :avatar)
  end



end
