# encoding: utf-8

require 'spec_helper'

describe TceSpecificationCapability do
  it "should be invalid when try to add a new inactive tce capability agreement" do
    agreement = Agreement.make!(:apoio_ao_turismo_inactive)

    subject.tce_capability_agreements.build(:agreement_id => agreement.id)
    subject.valid?
    subject.errors[:agreements].should include("não deve haver nenhum convênio inativo")
  end

  it "should be valid when have a persisted inactive tce capability agreement" do
    subject = TceSpecificationCapability.make!(:turismo)

    subject.valid?
    subject.errors[:agreements].should_not include("não deve haver nenhum convênio inativo")
  end

  it "should be valid when try to add a new active tce capability agreement" do
    agreement = Agreement.make!(:apoio_ao_turismo)

    subject.tce_capability_agreements.build(:agreement_id => agreement.id)
    subject.valid?
    subject.errors[:agreements].should_not include("não deve haver nenhum convênio inativo")
  end
end
