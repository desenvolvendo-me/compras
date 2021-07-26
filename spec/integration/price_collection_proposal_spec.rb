require 'spec_helper'

describe PriceCollectionProposal do
  describe '.not_invited' do
    it 'should return only proposals with email_invitation false' do
      proposal_invited = PriceCollectionProposal.make!(:proposta_de_coleta_de_precos, email_invitation: true)
      proposal_not_invited = PriceCollectionProposal.make!(:sobrinho_sa_proposta_without_user)

      expect(described_class.not_invited).to include(proposal_not_invited)
      expect(described_class.not_invited).to_not include(proposal_invited)
    end
  end
end
