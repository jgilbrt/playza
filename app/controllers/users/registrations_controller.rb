class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_team, only: [:edit, :update]

  def edit
    super
  end

def update
  self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

  # This is where update happens — pass account_update_params to your update_resource method
  if update_resource(resource, account_update_params)
    set_flash_message :notice, :updated if is_flashing_format?
    bypass_sign_in resource, scope: resource_name
    redirect_to after_update_path_for(resource)
  else
    clean_up_passwords resource
    set_minimum_password_length
    respond_with resource
  end
end

  private

  def set_team
    @team = current_user.team
    unless @team
      flash[:alert] = "You don't have a team assigned yet."
      redirect_to some_path # replace with your path
    end
  end

def update_resource(resource, params)
  permitted_params = params.permit(:email, team_attributes: [:avatar])
  if params[:password].blank? && params[:password_confirmation].blank? && params[:current_password].blank?
    resource.update_without_password(permitted_params)
  else
    resource.update_with_password(params)
  end
end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password,
                                 team_attributes: [:avatar])
  end

end
