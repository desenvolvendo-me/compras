# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_decorator'

describe LicitationProcessDecorator do
  let :time do
    Time.new(2012, 1, 4, 10)
  end

  context '#envelope_delivery_time' do
    context 'when do not have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.envelope_delivery_time).to be_nil
      end
    end

    context 'when have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(time)
      end

      it 'should localize envelope_delivery_time' do
        expect(subject.envelope_delivery_time).to eq '10:00'
      end
    end
  end

  context '#envelope_opening_time' do
    context 'when do not have envelope_opening_time' do
      before do
        component.stub(:envelope_opening_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.envelope_opening_time).to be_nil
      end
    end

    context 'when have envelope_opening_time' do
      before do
        component.stub(:envelope_opening_time).and_return(time)
      end

      it 'should return localized opening_delivery_time' do
        expect(subject.envelope_opening_time).to eq '10:00'
      end
    end
  end

  context '#parent_url' do
    context 'when have parent' do
      before do
        routes.stub(:edit_administrative_process_path).with(parent).and_return('link')
      end

      let :parent do
        double('AdministrativeProcess', :id => 1)
      end

      it 'should return a url to administrative process when has parent' do
        expect(subject.parent_url(parent)).to eq 'link'
      end
    end

    context 'when do not have parent' do
      before do
        routes.stub(:licitation_processes_path).and_return('link')
      end

      it 'should return a url to licitation processes when has not parent' do
        expect(subject.parent_url(nil)).to eq 'link'
      end
    end
  end

  describe "edit_parent_path" do

    before do
      routes.stub(:edit_licitation_process_path).with(component).and_return('licitation_process_link')
    end

    context "licitation process has a 'trading' modality" do

      before do
        component.stub(:presence_trading? => true)
      end

      it "returns the associated trading path if it exists" do
        trading = double(:trading)
        routes.stub(:edit_trading_path).with(trading).and_return('trading_link')
        component.stub(:trading => trading)

        expect(subject.edit_parent_path).to eq 'trading_link'
      end

      it "returns the licitation process path if there is no associated trading" do
        component.stub(:trading => nil)

        expect(subject.edit_parent_path).to eq 'licitation_process_link'
      end
    end

    it "returns the licitation process type otherwise" do
      component.stub(:presence_trading? => false)

      expect(subject.edit_parent_path).to eq 'licitation_process_link'
    end
  end

  describe "edit_parent_link" do

    context "licitation process has a 'trading' modality" do

      before do
        component.stub(:presence_trading? => true)
      end

      it "returns 'Voltar ao pregão presencial' if there is a associated trading" do
        trading = double(:trading)
        component.stub(:trading => trading)

        expect(subject.edit_parent_link).to eq 'Voltar ao pregão presencial'
      end

      it "returns 'Voltar ao processo licitatório' if there is no associated trading" do
        component.stub(:trading => nil)

        expect(subject.edit_parent_link).to eq 'Voltar ao processo licitatório'
      end
    end

    it "returns 'Voltar ao processo licitatório' otherwise" do
      component.stub(:presence_trading? => false)

      expect(subject.edit_parent_link).to eq 'Voltar ao processo licitatório'
    end
  end

end
