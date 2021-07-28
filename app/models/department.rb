class Department < Compras::Model
  attr_accessible :description, :purchasing_unit_id,
                  :department_people_attributes, :secretary_id,
                  :department_number

  attr_modal :description, :secretary_id, :purchasing_unit_id

  belongs_to :purchasing_unit
  belongs_to :secretary
  has_many :department_people

  validates :description, :presence => true
  validates :description, :uniqueness => {:case_sensitive => false}

  accepts_nested_attributes_for :department_people, allow_destroy: true

  orderize :description
  filterize

  scope :term, lambda {|q|
    where {description.like("#{q}%")}
  }

  scope :limit, lambda {|q| limit(q)}

  scope :by_secretary, ->(secretary) do
      where { secretary_id.eq secretary }
  end

  scope :by_user, ->(user_id) do
    department_ids = DepartmentPerson.where(user_id:user_id).pluck(:department_id)

    where { self.id.in department_ids }
  end

  scope :by_purchasing_unit_for_licitation_process, ->(licitation_process_id) do
    purchasing_unit_id = LicitationProcess.find(licitation_process_id).purchasing_unit.id
    where {|query| query.purchasing_unit_id.eq(purchasing_unit_id)}
  end

  def to_s
    "#{description}"
  end

end
