class DemandDepartment < Compras::Model
  belongs_to :demand
  belongs_to :department

  attr_accessible :demand_id, :department_id
end