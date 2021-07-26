require 'model_helper'
# require 'app/models/contract'
require 'app/models/contract_termination'
# require 'lib/annullable'
# require 'app/models/resource_annul'

describe ContractTermination do
  it { should belong_to :contract }
  it { should belong_to :dissemination_source }

  it { should have_one(:annul).dependent(:destroy) }

  it { should_not allow_value('12').for(:year) }
  it { should allow_value('1234').for(:year) }

  it 'should contact the number an the year to generate the to_s' do
    subject.stub(:number).and_return 1
    subject.stub(:year).and_return 2012

    expect(subject.to_s).to eq '1/2012'
  end
end
