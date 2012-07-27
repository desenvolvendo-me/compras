# encoding: utf-8
require 'decorator_helper'
require 'active_support/core_ext/array/grouping'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    context 'when do not have value_estimated' do
      before do
        subject.stub(:value_estimated).and_return(nil)
      end

      it 'should be nil' do
        subject.value_estimated.should be_nil
      end
    end

    context 'when have value_estimated' do
      before do
        component.stub(:value_estimated).and_return(500)
      end

      it 'should applies currency' do
        subject.value_estimated.should eq 'R$ 500,00'
      end
    end
  end

  context '#total_allocations_value' do
    context 'when do not have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(nil)
      end

      it 'should be nil' do
        subject.total_allocations_value.should be_nil
      end
    end

    context 'when have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(400)
      end

      it 'should applies precision' do
        subject.total_allocations_value.should eq '400,00'
      end
    end
  end

  context '#build_licitation_process_link' do
    context "released and persistend" do
      before do
        component.stub(:persisted?).and_return(true)
        component.stub(:released?).and_return(true)
        component.stub(:licitation_process).and_return(licitation_process)
        component.stub(:id).and_return(1)
      end

      let :licitation_process do
        double('licitation_process')
      end

      it "should return a link to a new licitation process" do
        routes.stub(:new_licitation_process_path).with(:administrative_process_id => 1).and_return('url')

        licitation_process.stub(:nil?).and_return(true)

        component.stub(:allow_licitation_process?).and_return(true)

        subject.build_licitation_process_link.should eq '<a href="url" class="button primary">Novo processo licitatório</a>'
      end

      it "should return a link to edit licitation process" do
        routes.stub(:edit_licitation_process_path).with(component.licitation_process, :administrative_process_id => 1).and_return('url')


        licitation_process.stub(:nil?).and_return(false)

        component.stub(:allow_licitation_process?).and_return(true)

        subject.build_licitation_process_link.should eq '<a href="url" class="button secondary">Editar processo licitatório</a>'
      end


      it "should not return a link to edit neither new licitation process when not allow licitation process" do
        component.stub(:allow_licitation_process?).and_return(false)

        subject.build_licitation_process_link.should be_nil
      end
    end

    context "neither persisted nor released" do
      it "should not return a link to new neither edit licitation_process if not persisted" do
        component.stub(:persisted?).and_return(false)
        component.stub(:released?).and_return(true)

        subject.build_licitation_process_link.should be_nil
      end

      it "should not return a link to new neither edit licitation_process if not released" do
        component.stub(:persisted?).and_return(true)
        component.stub(:released?).and_return(false)

        subject.build_licitation_process_link.should be_nil
      end
    end
  end

  context '#release_button' do
    context 'not persisted' do
      before do
        component.stub(:persisted?).and_return(false)
      end

      it "should be nil" do
        subject.release_button.should be_nil
      end
    end

    context 'not persisted, not waiting neither released' do
      before do
        component.stub(:persisted?).and_return(false)
        component.stub(:waiting?).and_return(false)
        component.stub(:released?).and_return(false)
      end

      it "should be nil" do
        subject.release_button.should be_nil
      end
    end

    context 'persisted and waiting' do
      before do
        component.stub(:id).and_return(1)
        component.stub(:persisted?).and_return(true)
        component.stub(:waiting?).and_return(true)
        routes.stub(:new_administrative_process_liberation_path).with(:administrative_process_id => 1).and_return('new_path')
      end

      it "should return a link to new administrative process liberation when is waiting" do
        subject.release_button.should eq '<a href="new_path" class="button primary">Liberar</a>'
      end
    end

    context "persisted and released but not waiting" do
      before do
        component.stub(:administrative_process_liberation).and_return(administrative_process_liberation)
        component.stub(:persisted?).and_return(true)
        component.stub(:waiting?).and_return(false)
        component.stub(:released?).and_return(true)
        routes.stub(:edit_administrative_process_liberation_path).and_return('edit_path')
      end

      let :administrative_process_liberation do
        double(:administrative_process_liberation, :id => 1)
      end

      it "should return a link to new administrative process liberation" do
        subject.release_button.should eq '<a href="edit_path" class="button secondary">Liberação</a>'
      end
    end
  end

  context '#date' do
    context 'when do not have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        subject.date.should eq nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        subject.date.should eq '31/12/2012'
      end
    end
  end

  context 'signatures' do
    context 'when do not have signatures' do
      before do
        component.stub(:signatures).and_return([])
      end

      it 'should return empty array' do
        subject.signatures_grouped.should eq []
      end
    end

    context 'when have signatures' do
      before do
        component.stub(:signatures).and_return(signature_configuration_items)
      end

      let :signature_configuration_item1 do
        double('SignatureConfigurationItem1')
      end

      let :signature_configuration_item2 do
        double('SignatureConfigurationItem2')
      end

      let :signature_configuration_item3 do
        double('SignatureConfigurationItem3')
      end

      let :signature_configuration_item4 do
        double('SignatureConfigurationItem4')
      end

      let :signature_configuration_item5 do
        double('SignatureConfigurationItem5')
      end

      let :signature_configuration_items do
        [
          signature_configuration_item1,
          signature_configuration_item2,
          signature_configuration_item3,
          signature_configuration_item4,
          signature_configuration_item5
        ]
      end

      it "should group signatures" do
        subject.signatures_grouped.should eq [
          [
            signature_configuration_item1,
            signature_configuration_item2,
            signature_configuration_item3,
            signature_configuration_item4
          ],
          [
            signature_configuration_item5
          ]
        ]
      end
    end
  end
end
