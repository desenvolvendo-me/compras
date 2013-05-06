class MapOfProposalReport < ActiveRelatus::Base
  extend EnumerateIt
  include Decore::Infection

  attr_accessor :order, :licitation_process_id

  has_enumeration_for :order, with: MapProposalReportOrder

  validates :order, :presence => true

  def licitation_process
    licitation_process_repository.find(licitation_process_id)
  end

  def item_creditor_proposals(item)
    records.where { purchase_process_item_id.eq item.id }
  end

  def average_unit_price_item(item)
    item_creditor_proposals(item).sum(:unit_price) / item_creditor_proposals(item).count
  end

  def average_total_price_item(item)
    average_unit_price_item(item) * item.quantity
  end

  protected

  def licitation_process_repository
    @licitation_process_repository ||= LicitationProcess
  end

  def normalize_attributes
    params = {}

    params[:licitation_process] = licitation_process_id
    params[:order] = order

    params
  end
end
