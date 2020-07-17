class Organ < Compras::Model
  attr_accessible :code, :initial, :name, :year, :organ_type, :category

  has_enumeration_for :category, :with => OrganCategory, :create_helpers => true
  has_enumeration_for :organ_type, :with => OrganType, :create_helpers => true

  has_many :expenses, foreign_key: 'unity_id'

  validates :name, :code, presence: true, uniqueness: true
  validates :category, presence: true
  validates :year, :mask => "9999", :allow_blank => true
  before_save :code_organ_type

  orderize "created_at"
  filterize

  scope :by_organ_type, lambda {|organ_type|
    where {|organ| organ.organ_type.eq(organ_type)}
  }


  def code_organ_type
    if self.organ_type == 'unity'
      errors.add(:code, :wrong_length, :count => 5) unless self.code.length == 6
    else
      errors.add(:code, :wrong_length, :count => 2) unless self.code.length == 2
    end
  end

  def to_s
    "#{code} - #{name}"
  end

end