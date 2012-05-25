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
  it { should_not validate_presence_of :social_identification_number_date }
  it { should_not validate_presence_of :contract_start_date }

  context 'when is company' do
    before do
      subject.stub(:company?).and_return(true)
    end

    it { should validate_presence_of :company_size }
    it { should validate_presence_of :main_cnae }
  end

  it "should not have social_identification_number_date greater than today" do
    subject.should_not allow_value(Date.tomorrow).
      for(:social_identification_number_date).
      with_message("deve ser antes de #{I18n.l Date.current}")
  end

  context 'when social_identification_number is filled' do
    before do
      subject.stub(:social_identification_number?).and_return('123')
    end

    it { should validate_presence_of :social_identification_number_date }
  end

  context 'when is autonomous' do
    before do
      subject.stub(:autonomous?).and_return(true)
    end

    it { should validate_presence_of :contract_start_date }
  end
end
