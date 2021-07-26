class SupplyRequestManagementsController < ApplicationController
  has_scope :page, :default => 1, :only => [:index, :modal], :unless => :disable_pagination?
  has_scope :per, :default => 10, :only => [:index, :modal], :unless => :disable_pagination?

  def index
    get_supply_request
  end

  private

  def get_supply_request
    @quantity = SupplyRequestServiceStatus.list.map{|x| {"#{x}" => 0}}.reduce(&:merge!)
    @suplly_requests = SupplyRequestServiceStatus.list.map{|x| {"#{x}" => []}}.reduce(&:merge!)

    sr = SupplyRequest.
        where("purchase_solicitation_id in (?) or user_id = ? ",
              get_purchase_solicitation,current_user.id )

    sr.each do |item|
      unless item.supply_request_attendances.last.nil?
        @quantity["#{item.supply_request_attendances.last.service_status}"] += 1
        @suplly_requests["#{item.supply_request_attendances.last.service_status}"].push(item.id)
      end
      @quantity["new"] += 1 if item.supply_request_attendances.count == 0
      @suplly_requests["new"].push(item.id) if item.supply_request_attendances.count == 0
    end
  end

  def get_purchase_solicitation
    use_pur_uni = UserPurchasingUnit.where(user_id:current_user.id).pluck(:purchasing_unit_id)
    departments = Department.where("compras_departments.purchasing_unit_id in (?)",use_pur_uni).pluck(:id)
    PurchaseSolicitation.where("department_id in (?)",departments).pluck(:id)
  end

end