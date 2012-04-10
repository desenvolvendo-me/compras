# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission'
require 'app/models/individual'
require 'app/enumerations/licitation_commission_responsible_role'

describe LicitationCommissionResponsible do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }

  it 'should validate presence of class_register when role is lawyer' do
    subject.valid?

    subject.errors.messages[:class_register].should be_nil

    subject.role = LicitationCommissionResponsibleRole::LAWYER

    subject.valid?

    subject.errors.messages[:class_register].should include "não pode ficar em branco"
  end
end
