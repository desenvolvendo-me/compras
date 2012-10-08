class SupplyAuthorizationEmailSender
  attr_accessor :supply_authorization, :context, :supply_authorization_mailer

  delegate :direct_purchase, :to => :supply_authorization
  delegate :render_to_pdf, :current_prefecture, :to => :context

  def initialize(supply_authorization, context, supply_authorization_mailer = SupplyAuthorizationMailer)
    self.supply_authorization = supply_authorization
    self.context = context
    self.supply_authorization_mailer = supply_authorization_mailer
  end

  def deliver
    if supply_authorization.annulled?
      deliver_annulment
    else
      deliver_authorization
    end
  end

  private

  def deliver_authorization
    supply_authorization_mailer.
      authorization_to_creditor(direct_purchase, current_prefecture, generate_pdf).
      deliver
  end

  def deliver_annulment
    supply_authorization_mailer.
      annulment_to_creditor(direct_purchase, current_prefecture, generate_pdf).
      deliver
  end

  def generate_pdf
    render_to_pdf "direct_purchases/supply_authorizations", :locals => { :resource => supply_authorization }
  end
end
