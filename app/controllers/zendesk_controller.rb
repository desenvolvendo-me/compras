class ZendeskController < ApplicationController
  ZENDESK_SHARED_SECRET = ENV["ZENDESK_SHARED_SECRET"]
  ZENDESK_SUBDOMAIN = ENV["ZENDESK_SUBDOMAIN"]
  ZENDESK_EMAIL = ENV["ZENDESK_EMAIL"]

  def index
    sign_into_zendesk
  end

  private

  def external_id
    "#{current_customer.domain}-#{current_user.email}"
  end

  def sign_into_zendesk
    iat = Time.now.to_i
    jti = "#{iat}/#{rand(36**64).to_s(36)}"

    payload = JWT.encode({
      iat: iat,
      jti: jti,
      name: current_user.name,
      email: ZENDESK_EMAIL,
      external_id: external_id,
      organization: 'icompras',
      ticket_restriction: 'organization',
      user_fields: { customer: current_customer.domain }
    }, ZENDESK_SHARED_SECRET)
    
    redirect_to zendesk_sso_url(payload)
  end

  def zendesk_sso_url(payload)
    "https://#{ZENDESK_SUBDOMAIN}.zendesk.com/access/jwt?jwt=#{payload}"
  end
end
