# encoding: utf-8
class PurchaseProcessAccreditationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Routes
  include ActionView::Helpers::TranslationHelper

  def must_have_creditors
    if creditors.empty?
      t("purchase_process_accreditation.messages.must_have_creditors")
    end
  end

  def accreditation_path(routes)
    persisted? ? routes.purchase_process_accreditation_path(component) : '#'
  end
end
