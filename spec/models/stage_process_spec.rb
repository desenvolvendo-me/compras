require 'model_helper'
require 'app/models/stage_process'

describe StageProcess do
  it { should have_many(:process_responsibles).dependent(:restrict) }

  it "return the description when call to_s" do
    subject.description = "1 Etapa"
    expect(subject.to_s).to eq '1 Etapa'
  end
end
