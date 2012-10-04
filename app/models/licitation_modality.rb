class LicitationModality < Compras::Model
  attr_accessible :regulatory_act_id, :description, :initial_value,
                  :final_value, :object_type, :invitation_letter,
                  :modality_type

  attr_modal :regulatory_act_id, :description, :object_type

  has_enumeration_for :modality_type, :with => AdministrativeProcessModality, :create_helpers => true
  has_enumeration_for :object_type, :with => AdministrativeProcessObjectType

  belongs_to :regulatory_act

  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict

  delegate :publication_date, :to => :regulatory_act, :prefix => true, :allow_nil => true

  validates :description, :regulatory_act, :initial_value, :object_type,
            :final_value, :presence => true

  with_options :allow_blank => true do |allow_blanking|
    allow_blanking.validates :initial_value, :final_value, :numericality => true
    allow_blanking.validates :initial_value, :uniqueness => { :scope => :final_value, :message => :initial_and_final_value_range_taken }
    allow_blanking.validates :final_value, :numericality => { :greater_than_or_equal_to => :initial_value, :message => :should_not_be_less_than_initial_value }
  end

  orderize :description
  filterize

  scope :by_object_type, lambda { |object_type|
    where { |modality| modality.object_type.eq(object_type) }
  }

  def to_s
    description
  end
end
