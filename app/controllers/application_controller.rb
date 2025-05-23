class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit :team_id and :role on sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:team_id, :role])

    # Permit them for account update as well if needed
    devise_parameter_sanitizer.permit(:account_update, keys: [:team_id, :role])
  end
end
