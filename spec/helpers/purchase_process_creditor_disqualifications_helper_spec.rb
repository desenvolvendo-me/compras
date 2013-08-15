require 'spec_helper'

describe PurchaseProcessCreditorDisqualificationsHelper do
  let(:resource)           { double(:resource, creditor: creditor, licitation_process: licitation_process) }
  let(:creditor)           { double(:creditor, to_s: 'Gabriel', id: 1) }
  let(:licitation_process) { double(:licitation_process, id: 1, to_s: '1/2012 - Pregão 1') }

  before { helper.stub(:resource).and_return resource }

  describe '#new_title' do
    it 'returns the new title' do
      expect(helper.new_title).to eql 'Desclassificar fornecedor Gabriel - Processo 1/2012 - Pregão 1'
    end
  end

  describe '#edit_title' do
    it 'returns the edit title' do
      expect(helper.edit_title).to eql 'Desclassificar fornecedor Gabriel - Processo 1/2012 - Pregão 1'
    end
  end

  describe 'check_proposal_item?' do
    let(:proposal_item) { double(:proposal_item, id: 1, 'disqualified?' => true) }

    it 'returns true when params got proposal the current proposal item' do
      helper.stub(:params).and_return({ proposal_item_ids: ['1'] })

      expect(helper.check_proposal_item?(proposal_item)).to be_true
    end

    it 'returns true when the proposal item is disqualified' do
      helper.stub(:params).and_return({ proposal_item_ids: [] })

      expect(helper.check_proposal_item?(proposal_item)).to be_true
    end
  end
end
