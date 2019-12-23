class SupplyOrdersController < CrudController

  def index
    @supply_orders = filter_by_department(collection)
  end

  protected

  def filter_by_department(collection)
    departments = DepartmentPerson.where(user_id: current_user.id).pluck(:department_id)
    collection.joins(:purchase_solicitation).where("compras_purchase_solicitations.department_id IN (?) ", departments)
  end
end
