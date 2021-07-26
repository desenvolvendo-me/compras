class PurchaseProcessTradingNegotiationsController < CrudController
  defaults resource_class: PurchaseProcessTrading

  actions :list, :edit, :update

  before_filter :accreditation_creditor, only: [:edit, :update]

  def list
  end

  def update
    update! do |success,failure|
      success.html { redirect_to list_purchase_process_trading_negotiation_path(resource) }
    end
  end

  private

  def accreditation_creditor
    @accreditation_creditor = PurchaseProcessAccreditationCreditor.find params[:accreditation_creditor_id]
  end
end
