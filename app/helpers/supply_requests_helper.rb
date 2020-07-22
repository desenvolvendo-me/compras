module SupplyRequestsHelper

  def disabled_material(object)
    disable = false
    disable = true if object.new_record?
    disable = true unless current_user.login.eql?(object.user.try(:login))
    disable
  end
 def can_destroy? obj
   resul = true
   resul = resul && obj.persisted?
   resul = resul && can?(:destroy, main_controller_name)
   resul = resul && !obj.updatabled
   resul = resul && !obj.supply_request_attendances.any?
   resul = resul && obj.user == current_user

   resul
 end
end