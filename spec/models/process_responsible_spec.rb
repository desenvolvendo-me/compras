require 'model_helper'
require 'app/models/process_responsible'

describe ProcessResponsible do
  it { should belong_to :stage_process }
  it { should belong_to :licitation_process }
  it { should belong_to :employee }

  it { should have_many(:judgment_commission_advices).through(:licitation_process) }
  it { should have_many(:licitation_commission_members).through(:judgment_commission_advices) }

  it { should have_one(:street).through(:employee) }
  it { should have_one(:neighborhood).through(:employee) }

  it { should validate_presence_of :stage_process }
  it { should validate_presence_of :licitation_process }

  it { should delegate(:execution_unit_responsible).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:street).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:neighborhood).allowing_nil(true).prefix(true) }
  it { should delegate(:cpf).to(:employee).allowing_nil(true) }
  it { should delegate(:name).to(:employee).allowing_nil(true) }
  it { should delegate(:phone).to(:employee).allowing_nil(true) }
  it { should delegate(:email).to(:employee).allowing_nil(true) }
  it { should delegate(:zip_code).to(:employee).allowing_nil(true) }
  it { should delegate(:city).to(:employee).allowing_nil(true) }
  it { should delegate(:state).to(:employee).allowing_nil(true) }
  it { should delegate(:acronym).to(:state).allowing_nil(true).prefix(true) }
  it { should delegate(:tce_mg_code).to(:city).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:stage_process).allowing_nil(true).prefix(true) }
end
