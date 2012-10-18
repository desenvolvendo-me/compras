# encoding: utf-8
require 'spec_helper'

describe ResourceAnnul do
  it 'validate uniqueness of annullable_id scoped to annullable_type' do
    resource_annul = ResourceAnnul.make!(:rescisao_de_contrato_anulada)

    subject.annullable_type = resource_annul.annullable_type
    subject.annullable_id = resource_annul.annullable_id

    subject.valid?

    expect(subject.errors[:annullable_id]).to include 'já está em uso'
  end
end