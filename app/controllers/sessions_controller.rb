class SessionsController < Devise::SessionsController
  skip_before_filter :check_concurrent_session

  def create
    if current_user && current_user.activated?
      super
      set_login_token  
    else
      sign_out(current_user)
      redirect_to new_user_session_path, :alert => I18n.t('devise.failure.disabled_user')
    end
  end

  def new
    flash[:notice] = params[:notice] if params[:notice].present?
    super
  end

  private

  def set_login_token
    token = Devise.friendly_token

    current_user.update_attribute(:login_token, token)
    session[:login_token] = token
  end
end
