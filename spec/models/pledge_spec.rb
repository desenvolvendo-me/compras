# encoding: utf-8
require 'model_helper'
require 'app/models/pledge'

describe Pledge do
  it { should belong_to :entity }
  it { should belong_to :management_unit }
  it { should belong_to :commitment_type }
  it { should belong_to :budget_allocation }
  it { should belong_to :pledge_category }
  it { should belong_to :expense_kind }
  it { should belong_to :pledge_historic }
  it { should belong_to :management_contract }
  it { should belong_to :licitation_modality }
  it { should belong_to :reserve_fund }
  it { should belong_to :creditor }
  it { should belong_to :founded_debt_contract }

  it { should validate_presence_of :licitation }
  it { should validate_presence_of :process }

  it 'should return id as to_s method' do
    subject.id = '1'

    subject.to_s.should eq '1'
  end

  it 'should return licitation_number/year as licitation method' do
    subject.licitation.should eq nil

    subject.licitation_number = '001'
    subject.licitation_year = '2012'

    subject.joined_licitation.should eq '001/2012'
  end

  it 'should return process_number/year as process method' do
    subject.process.should eq nil

    subject.process_number = '002'
    subject.process_year = '2013'

    subject.joined_process.should eq '002/2013'
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  it "should not have emission_date less than today" do
    subject.emission_date = Date.current - 1

    subject.valid?

    subject.errors[:emission_date].should include("deve ser em ou depois de #{I18n.l Date.current}")
  end
end
