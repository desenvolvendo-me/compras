require 'model_helper'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/employee'
require 'app/models/inscriptio_cursualis/address'
require 'app/models/address'
require 'app/models/persona/individual'
require 'app/models/individual'
require 'app/models/persona/identity'
require 'app/models/identity'
require 'app/models/licitation_commission_responsible'
require 'app/models/licitation_commission_member'
require 'app/models/judgment_commission_advice_member'

describe Individual do
  it "delegate to person to_s method" do
    subject.build_person
    subject.person.name = 'Gabriel Sobrinho'
    expect(subject.person.name).to eq subject.to_s
  end

  it { should have_one :employee }
  it { should have_one(:street).through(:person) }
  it { should have_one(:neighborhood).through(:person) }

  it { should have_many(:licitation_commission_responsibles).dependent(:restrict) }
  it { should have_many(:licitation_commission_members).dependent(:restrict) }
  it { should have_many(:judgment_commission_advice_members).dependent(:restrict) }

  it { should validate_presence_of :cpf }

  it { should delegate(:number).to(:identity).allowing_nil(true) }
  it { should delegate(:issuer).to(:identity).allowing_nil(true) }
  it { should delegate(:name).to(:person).allowing_nil(true) }
  it { should delegate(:city).to(:person).allowing_nil(true) }
  it { should delegate(:state).to(:person).allowing_nil(true) }
  it { should delegate(:zip_code).to(:person).allowing_nil(true) }
  it { should delegate(:phone).to(:person).allowing_nil(true) }
  it { should delegate(:email).to(:person).allowing_nil(true) }
end
