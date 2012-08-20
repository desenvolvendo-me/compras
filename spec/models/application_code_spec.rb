require 'model_helper'
require 'app/models/application_code'

describe ApplicationCode do
  it 'should return name as to_s' do
    subject.name = 'Geral'
    expect(subject.to_s).to eq 'Geral'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  it { should validate_presence_of :specification }
  it { should validate_presence_of :source }

  it { should have_many :tce_specification_capabilities }

  it 'variable should be by default false' do
    expect(subject.variable).to be_false
  end
end
