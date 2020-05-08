class Department < Compras::Model
  belongs_to :purchasing_unit
  has_many :department_people

  attr_accessible :description, :purchasing_unit_id, :department_people_attributes

  attr_modal :description

  validates :description, :presence => true

  accepts_nested_attributes_for :department_people, allow_destroy: true


  orderize :description
  filterize

  scope :term, lambda {|q|
    where {description.like("#{q}%")}
  }

  scope :limit, lambda {|q| limit(q)}

  scope :by_user, ->(user_id) do
    departments = Department.joins(:department_people).where(department_people:{user_id:user_id}).pluck(:id)

    where { self.id.in departments }
  end

  scope :by_purchasing_unit_for_licitation_process, ->(licitation_process_id) do
    purchasing_unit_id = LicitationProcess.find(licitation_process_id).purchasing_unit.id
    where {|query| query.purchasing_unit_id.eq(purchasing_unit_id)}
  end

  def to_s
    "#{description}"
  end

end
