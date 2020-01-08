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

  orderize "id DESC"
  filterize
end
