require 'model_helper'
require 'app/models/target_audience'

describe TargetAudience do
  it { should validate_presence_of :specification }

  it "should return specification as to_s" do
    subject.specification = 'Alunos da rede estudantil'

    subject.to_s.should eq 'Alunos da rede estudantil'
  end
end
