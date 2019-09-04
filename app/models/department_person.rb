class DepartmentPerson < Compras::Model
  # belongs_to :department
  # belongs_to :person

  attr_accessible :person_id

  belongs_to :department
  belongs_to :person

  validates :person, presence: true, uniqueness: { scope: :department_id }

  orderize arel_table[:id].desc

  before_create :create_for_descendents

  def to_s
    person.to_s
  end

  private

  def create_for_descendents
    department.descendants.each do |descendant|
      record = descendant.department_people.build(person_id: person_id)
      record.save(run_callbacks: false)
    end
  end

end
