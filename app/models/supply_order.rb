class SupplyOrder < Compras::Model
  include MaterialBalance
  include NumberSupply

  attr_accessible :licitation_process_id, :creditor_id, :authorization_date, :year, :observation, :updatabled,
                  :items_attributes, :invoices_attributes, :supply_requests_attributes,
                  :pledge_id, :purchase_solicitation_id, :contract_id, :purchase_form_id

  belongs_to :contract
  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor
  belongs_to :purchase_form

  has_many :items, class_name: 'SupplyOrderItem', dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :supply_requests, class_name: "SupplyOrderRequests", dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :invoices, allow_destroy: true
  accepts_nested_attributes_for :supply_requests, allow_destroy: true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :authorization_date, :contract, :purchase_solicitation, :licitation_process, presence: true
  validate :items_quantity_permitted

  orderize "id DESC"
  filterize

  # before_update :change_status_in_service

  def items_quantity_permitted
    message = calc_items_quantity(self.licitation_process, self.purchase_solicitation)
    errors.add(:items, "Quantidade solicitada indisponível. Quantidades disponíveis: #{message}") if message.present?
  end

  def pledge
    @pledge ||= Pledge.find(pledge_id) if pledge_id
  end

  def to_s
    "#{number}"
  end

  private

  def change_status_in_service
    if self.supply_request.any?
      self.updatabled? ? status = SupplyRequestStatus::DELIVERED : status = SupplyRequestStatus::IN_SERVICE
      self.supply_requests.each do |supply_order_request|
        supply_order_request.supply_request.update_attribute(:supply_request_status, status)
      end
    end
  end


end