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

  def company_sizes(company_size_repository = CompanySize)
    company_size_repository.all
  end
end
