class Customization < Compras::Model
  attr_accessible :model, :state_id, :data_attributes

  belongs_to :state

  has_many :data, :class_name => 'CustomizationData', :dependent => :destroy

  accepts_nested_attributes_for :data, :allow_destroy => true

  has_enumeration_for :model, :with => CustomizationModel

  orderize :id
  filterize

  def to_s
    "#{state} - #{model_humanize}"
  end
end
