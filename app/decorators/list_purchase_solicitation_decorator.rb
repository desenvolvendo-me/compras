class ListPurchaseSolicitationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :balance, :consumed_value, :expected_value,
              :resource_source,:licitation_process_id,
              :purchase_solicitation_id, :department

  def department
    purchase_solicitation.try(:department)
  end

  def purchase_solicitation_decorator
    edit_purchase_solicitation_path = "#{Rails.application.routes.url_helpers.edit_purchase_solicitation_path(purchase_solicitation)}"
    "<a class='edit_purchase_solicitation_path' href=#{edit_purchase_solicitation_path}>#{purchase_solicitation}</a>".html_safe
  end

end
