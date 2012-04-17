# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process'

describe LicitationProcessImpugnment do

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

  it "should not have new_envelope_delivery_date less than today" do
    subject.should_not allow_value(Date.yesterday).for(:new_envelope_delivery_date).
                                                   with_message("deve ser em ou depois de #{I18n.l Date.current}")
  end

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

  describe "validating new_envelope_opening_date and new_envelope_opening_time" do
    context "when new_envelope_opening_date less than new delivery date" do
      it "should not be valid" do
        subject.new_envelope_delivery_date = Date.tomorrow

        subject.should_not allow_value(Date.current).for(:new_envelope_opening_date).
                                                     with_message("deve ser em ou depois de #{I18n.l Date.tomorrow}")
      end
    end

    context "when new_envelope_opening_date equal new delivery date" do
      it "should not be valid if new_envelope_opening_time less than new delivery time" do
        subject.new_envelope_delivery_date = Date.current
        subject.new_envelope_delivery_time = Time.now
        subject.new_envelope_opening_date = Date.current

        subject.should_not allow_value(Time.now - 1.minute).for(:new_envelope_opening_time).
                                                            with_message("deve ser igual ou maior a hora de entrega do envelope")
      end

      it "should be valid if new_envelope_opening_time greater than or equal new delivery time" do
        subject.new_envelope_delivery_date = Date.current
        subject.new_envelope_delivery_time = Time.now
        subject.new_envelope_opening_date = Date.current
        subject.should allow_value(Time.now + 1.minute).for(:new_envelope_opening_time)
      end
    end
  end
end
