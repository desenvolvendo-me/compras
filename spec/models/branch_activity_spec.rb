require 'model_helper'
require 'app/models/branch_activity'

describe BranchActivity do
  it 'return name when converted to string' do
    subject.name = 'Desenvolvimento de Software'
    subject.name.should eq subject.to_s
  end

  it { should belong_to :cnae }
  it { should belong_to :branch_classification }

  it { should validate_presence_of :name }
  it { should validate_presence_of :cnae }
  it { should validate_presence_of :branch_classification }

end
