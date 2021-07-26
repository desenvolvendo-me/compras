class Generator::GeneratorSupplyOrder < Compras::Model
  attr_accessible :supply_requests_attributes, :control_code, :user_id

  attr_modal :control_code

  has_enumeration_for :status, :with => GeneratorSupplyOrderStatus,
                      :create_helpers => true

  mount_uploader :file, MonthlyMonitoringFileUploader do
    def store_dir
      "compras/#{model.customer.domain}/tce_export/monthly_monitoring/#{mounted_as}/#{model.id}"
    end
  end

  belongs_to :customer
  belongs_to :prefecture
  belongs_to :user

  has_many :supply_requests, class_name: "GeneratorSupplyOrderRequest", dependent: :destroy

  accepts_nested_attributes_for :supply_requests, allow_destroy: true

  delegate :organ_code, :organ_kind, to: :prefecture, allow_nil: true

  orderize 'id DESC'
  filterize

  after_create :set_control_code

  def set_control_code
    self.update_column("control_code", self.created_at.strftime("%y%m%d%H%M"))
  end

  def date
    Date.new(year, month)
  end

  def set_errors(error_messages)
    update_column :error_message, error_messages
  end

  def create_supply_orders
    errors = []

    supply_requests.each do |generate_supply_request|
      if SupplyOrder.joins(:supply_requests).where("compras_supply_order_requests.supply_request_id = ?", generate_supply_request.supply_request.id).any?
        errors.push("Pedido de Fornecimento #{generate_supply_request.supply_request.to_s} já contem Ordem de Fornecimento")
      else
        generate_supply_request.supply_request.licitation_process.licitation_process_ratifications.each do |creditor_winner|
          contract = Contract.
              where(licitation_process_id: generate_supply_request.supply_request.licitation_process_id).
              where(creditor_id: creditor_winner.creditor.id).
              last
          if contract
            create_supple_order(contract, generate_supply_request, creditor_winner)
          else
            errors.push("Fornecedor #{creditor_winner.creditor.name} sem contrato")
          end
        end
      end
    end

    set_errors(errors.join("<br/>"))
    set_status
    save!
  end

  def cancel!
    update_attribute :status, GeneratorSupplyOrderStatus::CANCELLED
  end

  protected

  def set_status
    error_message.blank? ? processed! : processed_with_errors!
  end

  private

  def create_supple_order(contract, generate_supply_request, creditor_winner)
    supply_order = SupplyOrder.create!(
        authorization_date: Date.today,
        year: generate_supply_request.supply_request.year,
        licitation_process_id: generate_supply_request.supply_request.licitation_process_id,
        contract_id: contract.id,
        purchase_solicitation_id: generate_supply_request.supply_request.purchase_solicitation_id
    )

    creditor_winner.licitation_process_ratification_items.each do |item|
      SupplyOrderItem.create(supply_order_id: supply_order.id, material_id: item.material.id, quantity: item.quantity)
    end

    SupplyOrderRequests.create(supply_order_id: supply_order.id, supply_request_id: generate_supply_request.supply_request.id)
  end

end
