class SupplyOrderManagementsController < ApplicationController
  def index
    redirect_to new_supply_order_management_path if params[:status].nil?
  end

  def new
    @groups = SupplyRequestAttendance.select(:service_status).
              group(:service_status).count
  end

end