class JudgmentForm < ActiveRecord::Base
  attr_accessible :description, :kind, :licitation_kind

  has_enumeration_for :kind, :with => JudgmentFormKind
  has_enumeration_for :licitation_kind, :with => LicitationKind

  has_many :administrative_processes, :dependent => :restrict

  validates :description, :kind, :licitation_kind, :presence => true
  validates :description, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
