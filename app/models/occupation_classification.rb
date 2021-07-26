class OccupationClassification < Unico::OccupationClassification
  attr_modal :name

  has_many :creditors, :dependent => :restrict

  orderize :code
  filterize

  def to_s
    "#{code} - #{name}"
  end
end
