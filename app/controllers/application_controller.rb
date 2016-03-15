class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #check_authorization :unless => :devise_controller?
  layout :layout_by_resource


  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to root_url, :alert => exception.message
  end

  def layout_by_resource
    if devise_controller? or current_user.blank?
      'devise'
    else
      'application'
    end
  end
end
