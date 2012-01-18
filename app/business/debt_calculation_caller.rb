# encoding: utf-8
class DebtCalculationCaller
  attr_accessor :property_transfer_id, :procedure

  def initialize(property_transfer_id, procedure = Procedure)
    self.property_transfer_id = property_transfer_id
    self.procedure = procedure
  end

  def call
    procedure.find('itbi').call(property_transfer_id)
  end
end
