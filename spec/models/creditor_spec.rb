require 'model_helper'
require 'app/models/creditor'

describe Creditor do
  it { should belong_to :person }
  it { should belong_to :occupation_classification }
  it { should belong_to :company_size }
  it { should belong_to :main_cnae }

  it { should validate_presence_of :person }
  it { should_not validate_presence_of :company_size }
  it { should_not validate_presence_of :main_cnae }
  it { should_not validate_presence_of :contract_start_date }

  context 'when is company' do
    before do
      subject.stub(:company?).and_return(true)
    end

    it { should validate_presence_of :company_size }
    it { should validate_presence_of :main_cnae }
  end

  context 'when is autonomous' do
    before do
      subject.stub(:autonomous?).and_return(true)
    end

    it { should validate_presence_of :contract_start_date }
  end
end
