class Department < Compras::Model
  belongs_to :purchasing_unit
  has_many :department_people

  attr_accessible :description, :purchasing_unit_id, :department_people_attributes

  attr_modal :description, :purchasing_unit_id

  validates :description, :presence => true

  accepts_nested_attributes_for :department_people, allow_destroy: true


  orderize :description
  filterize

  scope :term, lambda {|q|
    where {description.like("#{q}%")}
  }

  scope :limit, lambda {|q| limit(q)}

  def to_s
    "#{description}"
  end

end
