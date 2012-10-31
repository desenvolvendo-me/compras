class GovernmentProgram < Compras::Model
  attr_modal :descriptor_id, :description, :status

  has_enumeration_for :status

  belongs_to :descriptor

  orderize :description
  filterize

  def to_s
    description
  end
end
