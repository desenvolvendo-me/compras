class SupplyRequestManagementsController < ApplicationController
  has_scope :page, :default => 1, :only => [:index, :modal], :unless => :disable_pagination?
  has_scope :per, :default => 10, :only => [:index, :modal], :unless => :disable_pagination?

  def index
    get_supply_request
  end

  private

  def get_supply_request
    @quantity = {"new"=>0,"order_in_analysis"=>0,"order_in_financial_analysis"=>0,"returned_for_adjustment"=>0,"rejected"=>0,
                   "partially_answered"=>0,"fully_serviced"=>0,"doubts"=>0,"adjusted"=>0}
    @suplly_requests = {"new"=>[],"order_in_analysis"=>[],"order_in_financial_analysis"=>[],"returned_for_adjustment"=>[],
                        "rejected"=>[],"partially_answered"=>[],"fully_serviced"=>[],
                        "doubts"=>[],"adjusted"=>[]}

    sr = SupplyRequest.all
    sr.each do |item|
      unless item.supply_request_attendances.last.nil?
        @quantity["#{item.supply_request_attendances.last.service_status}"] += 1
        @suplly_requests["#{item.supply_request_attendances.last.service_status}"].push(item.id)
      end
      @quantity["new"] += 1 if item.supply_request_attendances.count == 0
      @suplly_requests["new"].push(item.id) if item.supply_request_attendances.count == 0
    end
  end
end