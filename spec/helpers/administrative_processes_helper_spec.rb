# encoding: utf-8
require 'spec_helper'

describe AdministrativeProcessesHelper do
  before do
    helper.stub(:resource).and_return(resource)
  end

  let :resource do
    double('AdministrativeProcess')
  end

  context '#build_licitation_process_link' do
    context "released and persistend" do
      before do
        resource.stub(:persisted?).and_return(true)
        resource.stub(:released?).and_return(true)
        resource.stub(:licitation_process).and_return(licitation_process)
        resource.stub(:id).and_return(1)
      end

      let :licitation_process do
        double('licitation_process')
      end

      it "should return a link to a new licitation process" do
        resource.stub(:allow_licitation_process?).and_return(true)
        licitation_process.stub(:nil?).and_return(true)

        helper.should_receive(:new_licitation_process_path).
          with(:administrative_process_id => 1).
          and_return('url')

        expect(helper.build_licitation_process_link).to eq '<a href="url" class="button primary">Novo processo licitatório</a>'
      end

      it "should return a link to edit licitation process" do
        licitation_process.stub(:nil?).and_return(false)
        resource.stub(:allow_licitation_process?).and_return(true)

        helper.should_receive(:edit_licitation_process_path).
          with(licitation_process, :administrative_process_id => 1).
          and_return('url')

        expect(helper.build_licitation_process_link).to eq '<a href="url" class="button secondary">Editar processo licitatório</a>'
      end


      it "should not return a link to edit neither new licitation process when not allow licitation process" do
        resource.stub(:allow_licitation_process?).and_return(false)

        expect(helper.build_licitation_process_link).to be_nil
      end
    end

    context "neither persisted nor released" do
      it "should not return a link to new neither edit licitation_process if not persisted" do
        resource.stub(:persisted?).and_return(false)
        resource.stub(:released?).and_return(true)

        expect(helper.build_licitation_process_link).to be_nil
      end

      it "should not return a link to new neither edit licitation_process if not released" do
        resource.stub(:persisted?).and_return(true)
        resource.stub(:released?).and_return(false)

        expect(helper.build_licitation_process_link).to be_nil
      end
    end
  end

  context '#release_button' do
    context 'not persisted' do
      before do
        resource.stub(:persisted?).and_return(false)
      end

      it "should be nil" do
        expect(helper.release_button).to be_nil
      end
    end

    context 'not persisted, not waiting neither released' do
      before do
        resource.stub(:persisted?).and_return(false)
        resource.stub(:waiting?).and_return(false)
        resource.stub(:released?).and_return(false)
      end

      it "should be nil" do
        expect(helper.release_button).to be_nil
      end
    end

    context 'persisted and waiting' do
      before do
        resource.stub(:id).and_return(1)
        resource.stub(:persisted?).and_return(true)
        resource.stub(:waiting?).and_return(true)
      end

      it "should return a link to new administrative process liberation when is waiting" do
        helper.should_receive(:new_administrative_process_liberation_path).
          with(:administrative_process_id => 1).
          and_return('new_path')

        expect(helper.release_button).to eq '<a href="new_path" class="button primary">Liberar</a>'
      end
    end

    context "persisted and released but not waiting" do
      before do
        resource.stub(:administrative_process_liberation).and_return(administrative_process_liberation)
        resource.stub(:persisted?).and_return(true)
        resource.stub(:waiting?).and_return(false)
        resource.stub(:released?).and_return(true)
      end

      let :administrative_process_liberation do
        helper.should_receive(:edit_administrative_process_liberation_path).
          and_return('edit_path')

        double(:administrative_process_liberation, :id => 1)
      end

      it "should return a link to new administrative process liberation" do
        expect(helper.release_button).to eq '<a href="edit_path" class="button secondary">Liberação</a>'
      end
    end
  end
end
