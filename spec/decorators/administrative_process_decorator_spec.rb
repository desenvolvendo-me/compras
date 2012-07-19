# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    before do
      component.stub(:value_estimated).and_return(500)
      helpers.stub(:number_to_currency).with(500).and_return('R$ 500,00')
    end

    it 'should applies currency' do
      subject.value_estimated.should eq 'R$ 500,00'
    end
  end

  context '#total_allocations_value' do
    before do
      component.stub(:total_allocations_value).and_return(400)
      helpers.stub(:number_with_precision).with(400).and_return('400,00')
    end

    it 'should applies precision' do
      subject.total_allocations_value.should eq '400,00'
    end
  end

  context '#build_licitation_process_link' do
    context "released and persistend" do
      before do
        component.stub(:persisted?).and_return(true)
        component.stub(:released?).and_return(true)
        component.stub(:licitation_process => licitation_process)
        component.stub(:id => 1)
      end

      let :licitation_process do
        double('licitation_process')
      end

      it "should return a link to a new licitation process" do
        routes.stub(:new_licitation_process_path).with(:administrative_process_id => 1).and_return('url')

        helpers.stub(:link_to).with('Novo processo licitatório', 'url', :class => "button primary").and_return('link_novo')

        licitation_process.stub(:nil?).and_return(true)

        component.stub(:allow_licitation_process? => true)

        subject.build_licitation_process_link.should eq 'link_novo'
      end

      it "should return a link to edit licitation process" do
        routes.stub(:edit_licitation_process_path).with(component.licitation_process, :administrative_process_id => 1).and_return('url')

        helpers.stub(:link_to).with('Editar processo licitatório', 'url', :class => "button secondary").and_return('link_edit')

        licitation_process.stub(:nil?).and_return(false)

        component.stub(:allow_licitation_process? => true)

        subject.build_licitation_process_link.should eq 'link_edit'
      end


      it "should not return a link to edit neither new licitation process when not allow licitation process" do
        component.stub(:allow_licitation_process? => false)

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
        component.stub(:persisted? => false)
      end

      it "should be nil" do
        subject.release_button.should be_nil
      end
    end

    context 'not persisted, not waiting neither released' do
      before do
        component.stub(:persisted? => false)
        component.stub(:waiting? => false)
        component.stub(:released? => false)
      end

      it "should be nil" do
        subject.release_button.should be_nil
      end
    end

    context 'persisted and waiting' do
      before do
        component.stub(:id => 1)
        component.stub(:persisted? => true)
        component.stub(:waiting? => true)
        routes.stub(:new_administrative_process_liberation_path).with(:administrative_process_id => 1).and_return('new_path')
        helpers.stub(:link_to).with('Liberar', 'new_path', { :class => 'button primary' }).and_return('new_link')
      end

      it "should return a link to new administrative process liberation when is waiting" do
        subject.release_button.should eq 'new_link'
      end
    end

    context "persisted and released but not waiting" do
      before do
        component.stub(:administrative_process_liberation => administrative_process_liberation)
        component.stub(:persisted? => true)
        component.stub(:waiting? => false)
        component.stub(:released? => true)
        routes.stub(:edit_administrative_process_liberation_path).and_return('edit_path')
        helpers.stub(:link_to).with('Liberação', 'edit_path', { :class => 'button secondary' }).and_return('edit_link')
      end

      let :administrative_process_liberation do
        double(:administrative_process_liberation, :id => 1)
      end

      it "should return a link to new administrative process liberation" do
        subject.release_button.should eq 'edit_link'
      end
    end
  end
end
