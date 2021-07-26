require 'model_helper'
require 'app/models/legal_analysis_appraisal'

describe LegalAnalysisAppraisal do
  it { should belong_to :responsible }
  it { should belong_to :licitation_process }

  it { should have_many(:licitation_process_ratifications).through(:licitation_process) }

  it { should validate_presence_of(:licitation_process) }
  it { should validate_presence_of(:appraisal_type) }
  it { should validate_presence_of(:reference) }
  it { should validate_presence_of(:appraisal_expedition_date) }
  it { should validate_presence_of(:responsible)}

  it { should delegate(:year).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:modality).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:description).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:cpf).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:street_name).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:neighborhood_name).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:city_tce_mg_code).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:state_acronym).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:zip_code).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:phone).to(:responsible).allowing_nil(true).prefix(true) }
  it { should delegate(:email).to(:responsible).allowing_nil(true).prefix(true) }

  it "should return process and year as process_and_year method" do
    subject.stub(:process).and_return(1)
    subject.stub(:year).and_return(2012)

    expect(subject.process_and_year).to eq '1/2012'
  end

  it 'should return name as to_s' do
    subject.reference = AppraisalReference::NOTICE
    expect(subject.to_s).to eq 'Edital'
  end
end
