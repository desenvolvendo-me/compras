# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationsHelper do
  before do
    helper.stub(:resource).and_return(resource)
  end

  let :resource do
    double(:resource, :id => 1)
  end

  context 'resource persisted' do
    before do
      resource.stub(:persisted?).and_return(true)
    end

    it 'should return release link when releasable' do
      resource.stub(:releasable?).and_return(true)

      helper.should_receive(:new_purchase_solicitation_liberation_path).
        with(:purchase_solicitation_id => resource.id).
        and_return('release_link')

      helper.release_liberation_link.should eq '<a href="release_link" class="button primary">Liberar</a>'
    end

    it 'should return release link when released?' do
      resource.stub(:released?).and_return(true)
      resource.stub(:releasable?).and_return(false)
      resource.stub(:liberation_id).and_return(1)

      helper.should_receive(:edit_purchase_solicitation_liberation_path).
        with(:purchase_solicitation_id => resource.id, :id => resource.liberation_id).
        and_return('liberation_link')

      helper.release_liberation_link.should eq '<a href="liberation_link" class="button primary">Liberação</a>'
    end

    it 'should return nil if is not released neither releasable' do
      resource.stub(:released?).and_return(false)
      resource.stub(:releasable?).and_return(false)

      helper.release_liberation_link.should be_nil
    end
  end

  it 'should return nil if not persisted' do
    resource.stub(:persisted?).and_return(false)

    helper.release_liberation_link.should be_nil
  end
end
