class UsersController < ApplicationController
  def chase_payment
    user = User.find(params[:id])
    # Your logic to send a payment reminder, e.g. send email, update status, etc.

    redirect_to users_path, notice: "Payment chase sent to #{user.email}"
  end
end
