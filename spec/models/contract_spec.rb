# encoding: utf-8
require 'model_helper'
require 'app/models/contract'
require 'app/models/pledge'

describe Contract do
  it { should belong_to(:entity) }

  it 'should return contract_number as to_s method' do
    subject.contract_number = '001'
    subject.to_s.should eq '001'
  end

  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of(:year) }
  it { should validate_presence_of(:entity) }
  it { should validate_presence_of(:contract_number) }
  it { should validate_presence_of(:process_number) }
  it { should validate_presence_of(:signature_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:kind) }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  context 'validating date' do
    it 'be invalid when the signature_date is after of end_date' do
      subject.signature_date = Date.new(2012, 2, 10)
      subject.end_date = Date.new(2012, 2, 1)

      subject.should be_invalid
      subject.errors[:end_date].should eq ['deve ser depois de 10/02/2012']
    end

    it 'be invalid when the signature_date is equal to end_date' do
      subject.signature_date = Date.new(2012, 2, 10)
      subject.end_date = subject.signature_date

      subject.should be_invalid
      subject.errors[:end_date].should eq ['deve ser depois de 10/02/2012']
    end

    it 'be valid when the end_date is after of signature_date' do
      subject.signature_date = Date.yesterday
      subject.end_date = Date.current

      subject.valid?

      subject.errors[:end_date].should be_empty
      subject.errors[:signature_date].should be_empty
    end
  end
end
