require 'model_helper'
require 'app/models/account_plan_configuration'

describe AccountPlanConfiguration do
  it { should belong_to :state }

  it { should validate_presence_of :description }
  it { should validate_presence_of :state }
  it { should validate_presence_of :year }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  context '#to_s' do
    it 'should return description at to_s call' do
      subject.description = 'Plano1'

      expect(subject.to_s).to eq 'Plano1'
    end
  end
end
