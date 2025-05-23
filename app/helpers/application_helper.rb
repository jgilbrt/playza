module ApplicationHelper
  # app/helpers/application_helper.rb
def current_team
  @current_team ||= current_user&.team
end

end
