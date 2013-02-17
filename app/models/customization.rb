class Customization < Compras::Model
  attr_accessible :model, :state_id, :data_attributes

  belongs_to :state

  has_many :data, :class_name => 'CustomizationData', :dependent => :destroy

  accepts_nested_attributes_for :data, :allow_destroy => true

  has_enumeration_for :model, :with => CustomizationModel

  validates :model, :state, :presence => true
  validates :model, :uniqueness => { :scope => :state_id, :allow_nil => true,
                    :message => :uniqueness_of_model_scoped_by_state_id }
  validate :must_have_data

  orderize :id
  filterize

  def to_s
    "#{state} - #{model_humanize}"
  end

  private

  def must_have_data
    if data.empty? || data.all? { |data| data.marked_for_destruction? }
      errors.add(:data, :empty)
    end
  end
end
