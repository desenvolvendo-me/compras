class DepartmentPerson < Compras::Model
  belongs_to :department
  belongs_to :person

  attr_accessible :person_id,:department_id

  scope :person_id, lambda { |id| where { person_id.eq(id) } }
  scope :department_id, lambda { |id| where { department_id.eq(id) } }

  validates :person,:department, presence: true

  orderize arel_table[:id].desc

  filterize
end
