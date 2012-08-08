# encoding: utf-8
require 'model_helper'
require 'app/models/regularization_or_administrative_sanction_reason'

describe RegularizationOrAdministrativeSanctionReason do
  it { should validate_presence_of :description }
  it { should validate_presence_of :reason_type }

  it "should return description like to_s" do
    subject.description = 'Advertência por desistência parcial da proposta devidamente justificada'

    expect(subject.to_s).to eq 'Advertência por desistência parcial da proposta devidamente justificada'
  end
end
