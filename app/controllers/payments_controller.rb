class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    # List all payments for your team players, ordered by newest first
    @payments = Payment.joins(:user).where(users: { team_id: @team.id }).order(created_at: :desc)
  end

  def show
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to payments_path, notice: 'Payment recorded successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      redirect_to payments_path, notice: 'Payment updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @payment.destroy
    redirect_to payments_path, notice: 'Payment deleted.'
  end

  private

  def set_team
    @team = current_user.team
  end

  def set_payment
    @payment = Payment.joins(:user).where(users: { team_id: @team.id }).find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:user_id, :amount, :status, :note)
  end
end
