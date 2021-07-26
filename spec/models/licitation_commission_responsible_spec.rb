require 'model_helper'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission'
require 'app/models/persona/individual'
require 'app/models/individual'

describe LicitationCommissionResponsible do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }

  it 'should validate presence of class_register when role is lawyer' do
    expect(subject).not_to validate_presence_of :class_register

    subject.role = LicitationCommissionResponsibleRole::LAWYER

    expect(subject).to validate_presence_of :class_register
  end
end
