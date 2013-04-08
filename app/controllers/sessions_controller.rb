class SessionsController < Devise::SessionsController
  skip_before_filter :check_concurrent_session

  def create
    super

    set_login_token
  end

  private

  def set_login_token
    token = Devise.friendly_token

    current_user.update_attribute(:login_token, token)
    session[:token] = token
  end
end
