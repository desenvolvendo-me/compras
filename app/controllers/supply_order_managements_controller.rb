class SupplyOrderManagementsController < ApplicationController
  has_scope :page, :default => 1, :only => [:index, :modal], :unless => :disable_pagination?
  has_scope :per, :default => 10, :only => [:index, :modal], :unless => :disable_pagination?

  def index
    redirect_to new_supply_order_management_path if params[:suplly_requests].nil?

    @sr = SupplyRequest.where("id in (?)",params[:suplly_requests])
  end

  def new
    get_sypply_request
  end

  private

  def get_sypply_request
    @quantidade = {"new"=>0,"order_in_analysis"=>0,"returned_for_adjustment"=>0,"rejected"=>0,
                   "partially_answered"=>0,"fully_serviced"=>0,"doubts"=>0,"adjusted"=>0}
    @suplly_requests = {"new"=>[],"order_in_analysis"=>[],"returned_for_adjustment"=>[],
                        "rejected"=>[],"partially_answered"=>[],"fully_serviced"=>[],
                        "doubts"=>[],"adjusted"=>[]}

    sr = SupplyRequest.all
    sr.each do |item|
      unless item.supply_request_attendances.last.nil?
        @quantidade["#{item.supply_request_attendances.last.service_status}"] += 1
        @suplly_requests["#{item.supply_request_attendances.last.service_status}"].push(item.id)
      end
    end
  end
end