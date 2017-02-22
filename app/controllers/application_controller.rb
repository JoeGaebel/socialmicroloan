class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def ensure_user_logged_in
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  def ensure_user_is_connected
    unless current_user.connected?
      flash[:danger] = 'Please connect via Stripe'
      redirect_to user_path(current_user)
    end
  end
end
