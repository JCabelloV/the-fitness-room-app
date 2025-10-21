class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.html { redirect_to root_path, alert: e.message.presence || "No autorizado" }
      format.json { render json: { error: "forbidden" }, status: :forbidden }
    end
  end


  protected

  def configure_permitted_parameters
    added_attrs = [ :first_name, :last_name, :rut, :email, :password, :password_confirmation ]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
