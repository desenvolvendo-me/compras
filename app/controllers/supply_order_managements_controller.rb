class SupplyOrderManagementsController < ApplicationController
  def index
    @groups = SupplyRequestAttendance.select(:service_status).
            group(:service_status).count
  end
end