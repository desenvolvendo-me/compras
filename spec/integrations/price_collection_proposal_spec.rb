require 'spec_helper'

describe PriceCollectionProposal do
  describe '.for_creditor' do
    it 'should filter proposals for a specific creditor' do
      sobrinho_proposal = PriceCollectionProposal.make!(:sobrinho_sa_proposta)
      wenderson_proposal = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos)

      expect(described_class.for_creditor(sobrinho_proposal.creditor)).to eq sobrinho_proposal
    end

    it 'returns nil when creditor has no proposal' do
      wenderson = Creditor.make!(:wenderson_sa_with_user)

      expect(described_class.for_creditor(wenderson)).to be_nil
    end
  end
end
