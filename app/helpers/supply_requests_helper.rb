module SupplyRequestsHelper

  def disabled_material(object)
    disable = false
    disable = true if object.new_record?
    disable = true unless current_user.login.eql?(object.user.login)
    disable
  end

end