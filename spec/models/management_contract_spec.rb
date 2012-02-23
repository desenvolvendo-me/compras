# encoding: utf-8
require 'model_helper'
require 'app/models/management_contract'

describe ManagementContract do
  it { should belong_to(:entity) }

  it 'should return id/year as to_s method' do
    subject.id = '1'
    subject.year = '2012'

    subject.to_s.should eq '1/2012'
  end

  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:entity) }
  it { should validate_presence_of(:contract_number) }
  it { should validate_presence_of(:process_number) }
  it { should validate_presence_of(:signature_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:description) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }
end
