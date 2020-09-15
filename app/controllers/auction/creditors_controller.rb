class Auction::CreditorsController < Auction::BaseController
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  skip_before_filter :authorize_resource!, :only => [:new, :create]

  has_scope :by_licitation_process, :allow_blank => true
  has_scope :term, :allow_blank => true
  has_scope :by_id, allow_blank: true
  has_scope :won_calculation, allow_blank: true
  has_scope :won_calculation_for_trading, allow_blank: true
  has_scope :without_direct_purchase_ratification, allow_blank: true
  has_scope :without_licitation_ratification, allow_blank: true
  has_scope :enabled_by_licitation, allow_blank: true
  has_scope :by_ratification_and_licitation_process_id, allow_blank: true
  has_scope :by_purchasing_unit, :allow_blank => true
  has_scope :by_contract, :allow_blank => true

  defaults resource_class: Person

  layout "electronic_auction"

  def  new
    object = build_resource
    object.personable = Company.new
    object.personable.cnpj = params[:cnpj]
  end

  def create
    create! do |success, failure|
      success.html { redirect_to new_auction_provider_path(cnpj: resource.personable.cnpj) }
      failure.html{ render :new}
    end
  end
end
