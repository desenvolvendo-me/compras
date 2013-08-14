require 'spec_helper'

describe PurchaseProcessProposalTiebreaksHelper do
  describe '#edit_title' do
    it 'returns the title for editing tiebreaks' do
      expect(helper.edit_title).to eq 'Desempate de Propostas'
    end
  end
end
