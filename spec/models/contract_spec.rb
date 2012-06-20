# encoding: utf-8
require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/contract'
require 'app/models/pledge'
require 'app/models/dissemination_source'
require 'app/models/creditor'
require 'app/models/service_or_contract_type'
require 'app/models/licitation_process'
require 'app/models/direct_purchase'
require 'app/models/budget_structure'
require 'app/models/employee'

describe Contract do
  it { should belong_to :entity }
  it { should belong_to :dissemination_source }
  it { should belong_to :creditor }
  it { should belong_to :service_or_contract_type }
  it { should belong_to :licitation_process }
  it { should belong_to :direct_purchase }
  it { should belong_to :budget_structure }
  it { should belong_to :budget_structure_responsible }
  it { should belong_to :lawyer }

  it 'should return contract_number as to_s method' do
    subject.contract_number = '001'
    subject.to_s.should eq '001'
  end

  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :sequential_number }
  it { should validate_presence_of :year }
  it { should validate_presence_of :entity }

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

  describe 'validating licitation process' do
    context 'without direct purchase' do
      it 'should be required' do
        subject.should validate_presence_of :licitation_process
      end
    end

    context 'with direct purchase' do
      before do
        subject.stub_chain(:direct_purchase, :present?).and_return true
      end

      it 'should not be required' do
        subject.should_not validate_presence_of :licitation_process
      end
    end
  end

  context 'validating direct purchase' do
    context 'without licitation process' do
      it 'should be required' do
        subject.should validate_presence_of :direct_purchase
      end
    end

    context 'with licitation process' do
      before do
        subject.stub_chain(:licitation_process, :present?).and_return true
      end

      it 'should not be required' do
        subject.should_not validate_presence_of :direct_purchase
      end
    end
  end
end
