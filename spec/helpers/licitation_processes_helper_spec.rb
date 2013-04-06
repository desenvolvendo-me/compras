# encoding: utf-8
require 'spec_helper'

describe LicitationProcessesHelper do
  describe '#accreditation_path_helper' do
    let(:resource) { double(:resource, :id => 1) }
    let(:purchase_process_accreditation) { double(:purchase_process_accreditation, :id => 2, :to_param => '2') }

    before do
      helper.stub(:resource => resource)
    end

    context 'when resource is not persisted' do
      before do
        resource.stub(:persisted? => false)
      end

      it 'should return nil' do
        expect(helper.accreditation_path_helper).to be_nil
      end
    end

    context 'when resource is persisted' do
      before do
        resource.stub(:persisted? => true)
      end

      context 'when resource has a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => purchase_process_accreditation)
        end

        it  'should return the link to edit the purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/2/edit?licitation_process_id=1'
        end
      end

      context 'when resource have not a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => nil)
        end

        it  'should return the link to a new purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/new?licitation_process_id=1'
        end
      end
    end
  end
end
