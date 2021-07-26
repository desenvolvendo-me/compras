require 'model_helper'
require 'app/models/licitation_commission_member'
require 'app/models/judgment_commission_advice_member'

describe LicitationCommissionMember do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should have_many(:judgment_commission_advice_members).dependent(:restrict) }

  it { should have_one(:regulatory_act).through(:licitation_commission) }
  it { should have_one(:person).through(:individual) }
  it { should have_one(:employee).through(:individual) }
  it { should have_one(:street).through(:individual) }
  it { should have_one(:neighborhood).through(:individual) }
  it { should have_one(:position).through(:employee) }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }

  it { should delegate(:cpf).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:zip_code).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:phone).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:email).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:city).to(:individual).allowing_nil(true) }
  it { should delegate(:tce_mg_code).to(:city).allowing_nil(true).prefix(true) }
  it { should delegate(:acronym).to(:state).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:position).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:street).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:neighborhood).allowing_nil(true).prefix(true) }
  it { should delegate(:permanent?).to(:licitation_commission).allowing_nil(true).prefix(true) }
  it { should delegate(:nomination_date).to(:licitation_commission).allowing_nil(true).prefix(true) }
  it { should delegate(:classification_ordinance?).to(:regulatory_act).allowing_nil(true).prefix(true) }
  it { should delegate(:classification_decree?).to(:regulatory_act).allowing_nil(true).prefix(true) }
  it { should delegate(:act_number).to(:regulatory_act).allowing_nil(true).prefix(true) }
  it { should delegate(:vigor_date).to(:regulatory_act).allowing_nil(true).prefix(true) }
  it { should delegate(:end_date).to(:regulatory_act).allowing_nil(true).prefix(true) }

  it 'should return the individual_to_s as to_s method' do
    individual = double(:to_s => 'name 1')

    subject.stub(:individual).and_return(individual)

    expect(subject.to_s).to eq 'name 1'
  end
end
