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
require 'app/models/delivery_schedule'
require 'app/models/occurrence_contractual_historic'

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
  it { should have_many(:delivery_schedules).dependent(:destroy).order(:sequence) }
  it { should have_many(:occurrence_contractual_historics).dependent(:restrict) }

  it 'should return contract_number as to_s method' do
    subject.contract_number = '001'
    subject.to_s.should eq '001'
  end

  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :sequential_number }
  it { should validate_presence_of :year }
  it { should validate_presence_of :entity }
  it { should validate_presence_of :contract_number }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :dissemination_source }
  it { should validate_presence_of :content }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :execution_type }
  it { should validate_presence_of :contract_guarantees }
  it { should validate_presence_of :contract_value }
  it { should validate_presence_of :contract_validity }
  it { should validate_presence_of :signature_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :budget_structure }
  it { should validate_presence_of :budget_structure_responsible }
  it { should validate_presence_of :lawyer }
  it { should validate_presence_of :lawyer_code }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :service_or_contract_type }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  describe 'validating parent' do
    it 'should be required when the kind is amendment' do
      subject.stub(:amendment?).and_return true

      subject.should validate_presence_of :parent
    end

    it 'should not be required when the kind is not amendment' do
      subject.stub(:amendment?).and_return false

      subject.should_not validate_presence_of :parent
    end
  end

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

  context 'validating licitation process or direct purchase' do
    let :licitation_process do
      double(:licitation_process)
    end

    let :direct_purchase do
      double(:direct_purchase)
    end

    it 'only licitation process must be valid' do
      subject.stub(:licitation_process => licitation_process)
      subject.valid?
      subject.errors[:licitation_process].should be_empty
    end

    it 'only direct purchase must be valid' do
      subject.stub(:direct_purchase => direct_purchase)
      subject.valid?
      subject.errors[:licitation_process].should be_empty
    end

    it 'no licitation_process and no direct_purchase must be invalid' do
      subject.valid?
      subject.errors[:licitation_process].should eq ["selecione um processo licitário ou uma compra direta, mas não ambos"]
    end

    it 'both must be invalid' do
      subject.stub(:direct_purchase => direct_purchase)
      subject.stub(:licitation_process => licitation_process)
      subject.valid?
      subject.errors[:licitation_process].should eq ["selecione um processo licitário ou uma compra direta, mas não ambos"]
    end
  end

  describe 'setting contract modality' do
    it 'should set the modality to "licitation_process" when a licitation process is present' do
      subject.stub(:licitation_process_id).and_return 1

      subject.run_callbacks(:create)

      subject.modality.should eq ContractModality::LICITATION_PROCESS
    end

    it 'should set the modality to "direct_purchase" when no licitation process is present' do
      subject.stub(:licitation_process_id).and_return nil

      subject.run_callbacks(:create)

      subject.modality.should eq ContractModality::DIRECT_PURCHASE
    end
  end
end
