# encoding: utf-8
require 'model_helper'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/licitation_process'
require 'app/models/licitation_process_appeal'

describe LicitationProcessAppeal do

  it 'should return id as to_s method' do
    subject.id = 2

    expect(subject.to_s).to eq '2'
  end

  it { should belong_to :person }
  it { should belong_to :licitation_process }

  it { should validate_presence_of :person }
  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :appeal_date }

  it { should delegate(:description).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process_date).to(:licitation_process).allowing_nil(true).prefix(true) }

  context 'validating appeal_date' do
    before(:each) do
      subject.stub(:licitation_process).and_return(licitation_process)
    end

    let :licitation_process do
      double('licitation_process', :process_date => Date.new(2012, 12, 13))
    end

    it 'be valid when appeal_date is after process_date' do
      expect(subject).to allow_value(Date.new(2012, 12, 20)).for(:appeal_date)
    end

    it 'be valid when appeal_date is equals to process_date' do
      expect(subject).to allow_value(Date.new(2012, 12, 13)).for(:appeal_date)
    end

    it 'be invalid when appeal_date is before process_date' do
      expect(subject).not_to allow_value(Date.new(2012, 1, 1)).for(:appeal_date).
                                                           with_message('deve ser maior ou igual a data do processo (13/12/2012)')
    end
  end
end
