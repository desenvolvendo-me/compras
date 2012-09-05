class AgreementAdditiveNumberGenerator
  attr_accessor :agreement_object

  delegate :last_persisted_additive, :agreement_additives,
           :to => :agreement_object

  def initialize(agreement_object)
    self.agreement_object = agreement_object
  end

  def generate!
    next_number = last_number.succ

    agreement_additives.each do |additive|
      next if additive.number

      additive.number = next_number
      next_number = next_number.succ
    end
  end

  protected

  def last_number
    return 0 unless last_persisted_additive

    last_persisted_additive.number
  end
end
