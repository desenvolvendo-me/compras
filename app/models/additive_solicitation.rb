class AdditiveSolicitation < Compras::Model
  include NumberSupply

  attr_accessible :year, :licitation_process_id, :creditor_id, :department_id, :items_attributes

  belongs_to :creditor
  belongs_to :department
  belongs_to :licitation_process

  has_many :items, class_name: 'AdditiveSolicitationItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
           to: :licitation_process, allow_nil: true

  validates :creditor, :department, :presence => true

  orderize "id DESC"
  filterize

  validate :items_margen_permitted, :finished_status?

  before_validation :set_current_year

  def items_margen_permitted
    self.items.each do |item|
      response = AdditiveSolicitation.calc_items_margin(self.licitation_process.id, item.material.id, item.quantity, item.value)
      errors.add(:items, response["message"]) if response["message"].present?
    end
  end

  def self.calc_items_margin(licitation_process_id, material_id, quantity, value)
    response = {}
    limit_marge = 25

    additived_margen = sum_additive_solicitation_items(licitation_process_id, material_id)

    item = PurchaseProcessItem.where(licitation_process_id: licitation_process_id).where(material_id: material_id).first

    margen, margen_available = calculator_margin(additived_margen, item, limit_marge, quantity, value)

    response["margen"] = margen
    response["margen_available"] = margen_available
    response["message"] = "Margem solicitada indisponível. Margem disponível: #{item.material} (#{margen_available}%)" if margen < 0
    response
  end

  private

  def self.calculator_margin(additived_margen, item, limit_marge, quantity, value)
    solicited_margen = quantity * value
    max_margen = item.quantity * item.unit_price.to_f
    margen = (limit_marge - (((solicited_margen + additived_margen) / max_margen) * 100)).round(2)
    margen_available = (limit_marge - (((additived_margen) / max_margen) * 100)).round(2)
    return margen, margen_available
  end

  def self.sum_additive_solicitation_items(licitation_process_id, material_id)
    sum = AdditiveSolicitationItem.joins(:additive_solicitation).where("compras_additive_solicitations.licitation_process_id = #{licitation_process_id}").where("compras_additive_solicitation_items.material_id = #{material_id}").group("compras_additive_solicitation_items.material_id").select("SUM(compras_additive_solicitation_items.quantity * compras_additive_solicitation_items.value) AS total").first
    sum ? sum.total.to_i : 0
  end

  def set_current_year
    self.year = year.blank? ? Date.today.year : year
  end

  def finished_status?
    errors.add(:licitation_process, :unable_to_save) if licitation_process.status == "approved"
  end
end
