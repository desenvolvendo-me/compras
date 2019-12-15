class SupplyOrder < Compras::Model
  attr_accessible :licitation_process_id, :creditor_id, :authorization_date,
    :items_attributes, :year, :pledge_id,:purchase_solicitation_id

  belongs_to :purchase_solicitation
  belongs_to :licitation_process
  belongs_to :creditor

  has_many :items, class_name: 'SupplyOrderItem', dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  delegate :modality_number, :modality_humanize, :type_of_removal_humanize,
    to: :licitation_process, allow_nil: true

  validates :authorization_date, :creditor, :licitation_process, presence: true

  orderize "id DESC"
  filterize

  def pledge
    @pledge ||= Pledge.find(pledge_id) if pledge_id
  end
end