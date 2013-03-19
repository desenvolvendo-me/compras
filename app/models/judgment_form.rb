class JudgmentForm < Compras::Model
  attr_accessible :enabled

  has_enumeration_for :kind, :with => JudgmentFormKind, :create_helpers => true
  has_enumeration_for :licitation_kind, :with => LicitationKind, :create_helpers => true

  has_many :licitation_processes, :dependent => :restrict

  validates :description, :kind, :licitation_kind, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }
  validates :kind, :uniqueness => { :scope => :licitation_kind, :message => :already_in_use_for_this_licitation_kind, :allow_blank => true }

  scope :enabled, lambda { where { enabled.eq(true) } }

  orderize :description
  filterize

  def to_s
    description
  end
end
