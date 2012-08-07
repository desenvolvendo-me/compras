# encoding: utf-8
require 'model_helper'
require 'app/models/reserve_fund'
require 'app/models/pledge'
require 'lib/annullable'
require 'app/models/resource_annul'

describe ReserveFund do
  it 'should return to_s as id/year' do
    subject.id = 1
    subject.stub(:year).and_return(2012)
    subject.to_s.should eql '1/2012'
  end

  it { should belong_to :descriptor }
  it { should belong_to :budget_allocation }
  it { should belong_to :reserve_allocation_type }
  it { should belong_to :licitation_modality }
  it { should belong_to :creditor}
  it { should belong_to :licitation_process }

  it { should have_one(:annul).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:restrict) }

  it { should validate_presence_of :descriptor }
  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }
  it { should validate_presence_of :reserve_allocation_type }
  it { should validate_presence_of :date }

  context 'validating date' do
    before(:each) do
      described_class.stub(:last).and_return(double(:date => Date.new(2011, 12, 31)))
      described_class.stub(:any?).and_return(true)
    end

    it 'should be valid when date is equal to last' do
      subject.should allow_value(Date.new(2011, 12, 31)).for(:date)
    end

    it 'should not be valid when date is greater than last' do
      subject.should_not allow_value(Date.new(2011, 12, 21)).for(:date).with_message("deve ser maior ou igual a data da última reserva (31/12/2011)")
    end
  end

  it 'should validate that the value not exceed available reserve' do
    budget_allocation = double(:amount => 500.0, :reserved_value => 300)
    subject.stub(:budget_allocation).and_return(budget_allocation)

    subject.value = 200

    subject.valid?

    subject.errors.messages[:value].should be_nil

    subject.value = 201

    subject.valid?

    subject.errors.messages[:value].should include 'está acima do valor disponível para a dotação selecionada (R$ 200,00)'
  end

  describe '#annul!' do
    it 'update the status attribute to annulled' do
      subject.should_receive(:update_column).with(:status, 'annulled')

      subject.annul!
    end
  end
end
