class PingController < ApplicationController
  prepend_before_filter :skip_timeout

  def ping
    if timedout?
      render :nothing => true, :status => :unauthorized
    else
      render :nothing => true
    end
  end

  protected

  def timedout?
    current_user.timedout?(last_request_at)
  end

  def last_request_at
    warden.session(:user)['last_request_at']
  end

  def skip_timeout
    request.env["devise.skip_timeout"] = true
  end
end
