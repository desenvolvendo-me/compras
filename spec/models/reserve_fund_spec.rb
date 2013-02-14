# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_fund'
require 'app/models/pledge'

describe ReserveFund do
  it 'should return to_s as id/year' do
    subject.id = 1
    subject.stub(:year).and_return(2012)
    expect(subject.to_s).to eql '1/2012'
  end

  it { should belong_to :descriptor }
  it { should belong_to :budget_allocation }
  it { should belong_to :creditor}
  it { should belong_to :licitation_process }
end
