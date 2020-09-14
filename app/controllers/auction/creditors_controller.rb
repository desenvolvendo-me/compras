class Auction::CreditorsController < Auction::BaseController
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

  def  new
    object = build_resource
    object.personable = Company.new
  end

  def create
    create! do |success, failure|
      success.html { update_user(resource) }
      failure.html{ render :new}
    end
  end


  private

  def update_user resource
    if current_user.provider?
      current_user.update_attributes(authenticable_id: resource.creditor.id, authenticable_type: AuthenticableType::CREDITOR)
    end
    redirect_to root_path
  end
end
