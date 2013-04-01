require 'model_helper'
require 'app/models/legal_analysis_appraisal'

describe LegalAnalysisAppraisal do
  it { should belong_to :responsible }
  it { should belong_to :licitation_process }

  it { should validate_presence_of(:licitation_process) }
  it { should validate_presence_of(:appraisal_type) }
  it { should validate_presence_of(:reference) }
  it { should validate_presence_of(:appraisal_expedition_date) }
  it { should validate_presence_of(:responsible)}

  it { should delegate(:year).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:modality).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:description).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:number).to(:responsible).allowing_nil(true).prefix(:true) }
  it { should delegate(:issuer).to(:responsible).allowing_nil(true).prefix(:true) }

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
