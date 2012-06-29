class LowerPaymentsController < CrudController
  before_filter :check_default_interest_setting, :only => %w(new create edit update)
  before_filter :check_default_penalty_setting, :only => %w(new create edit update)

  def new
    object = build_resource
    object.payment_date = Date.current

    super
  end

  protected

  def create_resource(object)
    if super
      transfer_property = TransferProperty.new(object)
      transfer_property.transfer!
    end
  end

  def check_default_interest_setting
    unless Setting.fetch(:default_interest)
      redirect_to collection_url, :alert => t("errors.compras.messages.missing_default_interest_setting")
    end
  end

  def check_default_penalty_setting
    unless Setting.fetch(:default_penalty)
      redirect_to collection_url, :alert => t("errors.compras.messages.missing_default_penalty_setting")
    end
  end
end
