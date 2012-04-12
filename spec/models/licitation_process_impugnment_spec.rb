# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process'

describe LicitationProcessImpugnment do

  it { should belong_to :licitation_process }
  it { should belong_to :person }
  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :related }
  it { should validate_presence_of :person }
  it { should validate_presence_of :situation }

  context "validating impugnment_date" do
    let(:licitation_process) { double('licitation_process', :id => 1, :process_date => Date.current) }

    it 'should be equal or greater than process_date' do
      subject.stub(:impugnment_date => Date.yesterday, :licitation_process => licitation_process)
      subject.valid?
      subject.errors[:impugnment_date].should include "deve ser maior ou igual a data do processo"
    end

    it 'should be valid when is blank' do
      subject.stub(:impugnment_date => '', :licitation_process => licitation_process)
      subject.valid?
      subject.errors[:impugnment_date].should_not include "não é uma data válida"
    end
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
end
