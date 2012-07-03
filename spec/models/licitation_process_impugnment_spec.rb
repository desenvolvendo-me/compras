# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process'

describe LicitationProcessImpugnment do

  describe 'default values' do
    it 'uses Situation::PENDING as default for situation' do
      subject.situation.should eq Situation::PENDING
    end
  end

  it { should belong_to :licitation_process }
  it { should belong_to :person }
  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :impugnment_date }
  it { should validate_presence_of :related }
  it { should validate_presence_of :person }
  it { should validate_presence_of :situation }

  context 'when new_envelope_opening_date and new_envelope_delivery_date exists and are different' do
    before do
      subject.new_envelope_delivery_date = Date.tomorrow
      subject.new_envelope_opening_date = Date.current
    end

    it { should allow_value("11:11").for(:new_envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:new_envelope_delivery_time) }

    it { should allow_value("11:11").for(:new_envelope_opening_time) }
    it { should_not allow_value("44:11").for(:new_envelope_opening_time) }
  end

  describe "validating judgment_date" do
    it 'should be equal or greater than impugnment_date' do
      subject.stub(:judgment_date => Date.yesterday, :impugnment_date => Date.current)
      subject.valid?
      subject.errors[:judgment_date].should include "deve ser maior ou igual a data da impugnação"
    end

    it 'should be valid when is blank' do
      subject.stub(:judgment_date => '')
      subject.valid?
      subject.errors[:judgment_date].should_not include ["não é uma data válida", "não pode ser vazio"]
    end
  end

  context 'validating impugnment_date' do
    before(:each) do
      subject.stub(:licitation_process).and_return(licitation_process)
    end

    let :licitation_process do
      double('licitation_process', :process_date => Date.new(2012, 12, 13))
    end

    it 'be valid when impugnment_date is after process_date' do
      subject.should allow_value(Date.new(2012, 12, 20)).for(:impugnment_date)
    end

    it 'be valid when impugnment_date is equals to process_date' do
      subject.should allow_value(Date.new(2012, 12, 13)).for(:impugnment_date)
    end

    it 'be invalid when impugnment_date is before process_date' do
      subject.should_not allow_value(Date.new(2012, 1, 1)).for(:impugnment_date).
                                                           with_message('deve ser maior ou igual a data do processo (13/12/2012)')
    end
  end
end
