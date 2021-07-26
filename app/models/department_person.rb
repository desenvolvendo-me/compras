class DepartmentPerson < Compras::Model
  belongs_to :department
  belongs_to :user
  # belongs_to :person

  attr_accessible :department_id,:user_id

  scope :user_id, lambda { |id| where { person_id.eq(id) } }
  scope :department_id, lambda { |id| where { department_id.eq(id) } }

  validates :user,:department, presence: true
  validates_uniqueness_of :user_id, scope: :department_id,
                          :message => :already_exist_other_register_with_this_informations

  orderize arel_table[:id].desc

  filterize

end
