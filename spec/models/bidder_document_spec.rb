# encoding: utf-8
require 'model_helper'
require 'app/models/bidder_document'
require 'app/models/bidder'
require 'app/models/document_type'

describe BidderDocument do
  it { should belong_to :bidder }
  it { should belong_to :document_type }

  it { should validate_presence_of :document_type }

  context "validations" do
    context "with document_number filled" do
      before { subject.stub(:document_number).and_return('1') }

      it { should validate_presence_of :emission_date }
      it { should validate_presence_of :validity }
    end

    context "with document_number filled" do
      before { subject.stub(:emission_date).and_return(Date.current) }

      it { should validate_presence_of :document_number }
      it { should validate_presence_of :validity }
    end

    context "with document_number filled" do
      before { subject.stub(:validity).and_return(Date.current) }

      it { should validate_presence_of :document_number }
      it { should validate_presence_of :emission_date }
    end
  end

  context 'validate emission_date based on Date.current' do
    context 'based on Date.current' do
      it { should allow_value(Date.current).for(:emission_date) }

      it { should allow_value(Date.yesterday).for(:emission_date) }

      it 'should not allow date after today' do
        expect(subject).not_to allow_value(Date.tomorrow).for(:emission_date).
                                                          with_message("deve ser igual ou anterior a data atual (#{I18n.l(Date.current)})")
      end
    end
  end

  context 'validate validity related with emission_date' do
    before do
      subject.stub(:emission_date).and_return(emission_date)
    end

    let :emission_date do
      Date.current + 10.days
    end

    it 'should allow validity date after emission_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:validity)
    end

    it 'should allow validity date equals to emission_date' do
      expect(subject).to allow_value(emission_date).for(:validity)
    end

    it 'should not allow validity date before emission_date' do
      expect(subject).not_to allow_value(Date.current).for(:validity).
                                                       with_message("deve ser igual ou posterior a data de emissão (#{I18n.l emission_date})")
    end
  end

  context '#expired' do
    it 'should return false' do
      subject.stub(:validity => Date.new(4000, 1, 1))

      expect(subject.expired?).to be false
    end

    it 'should return true' do
      subject.stub(:validity => Date.new(2000, 1, 1))

      expect(subject.expired?).to be true
    end
  end
end
