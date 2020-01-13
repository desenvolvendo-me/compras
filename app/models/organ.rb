class Organ < Compras::Model
  attr_accessible :code, :initial, :name, :year, :organ_type, :category

  has_enumeration_for :category, :with => OrganCategory, :create_helpers => true
  has_enumeration_for :organ_type, :with => OrganType, :create_helpers => true

  validates :name, :code, presence: true, uniqueness:true
  validates :category, presence: true
  validates :year, :mask => "9999", :allow_blank => true
  before_save :code_category
  before_save :code_organ_type

  orderize "created_at"
  filterize

  def code_category
    if self.category == 'analytical'
      errors.add(:code, :wrong_length, :count=> 5) unless self.code.length == 6
    else
      errors.add(:code, :wrong_length, :count=> 2) unless self.code.length == 2
    end
  end

  def code_organ_type
    if self.organ_type == 'unity'
      errors.add(:code, :wrong_length, :count=> 5) unless self.code.length == 6
    else
      errors.add(:code, :wrong_length, :count=> 2) unless self.code.length == 2
    end
  end

  def to_s
    "#{code}"
  end

end