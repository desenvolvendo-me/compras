# encoding: utf-8
require 'spec_helper'

describe "LicitationCommission" do

  describe "#exoneration_date" do
    it "is not mandatory" do
      licitation_commission = LicitationCommission.make(:comissao_pregao_presencial,
                                                        :exoneration_date => nil)
      expect(licitation_commission).to be_valid
    end
  end

  describe "validations" do
    it "requires a auctioneer if commission is of type 'trading'" do
      licitation_commission = LicitationCommission.make(:comissao_pregao_presencial,
                                                        :licitation_commission_members => [])
      licitation_commission.valid?

      expect(licitation_commission.errors.full_messages).to include "Membros da comissão de licitação deve ter ao menos um pregoeiro"
    end

    it "requires a auctioneer if commission is of type 'trading'" do
      licitation_commission = LicitationCommission.make(:comissao_pregao_presencial,
                                                        :licitation_commission_members => [])
      licitation_commission.valid?

      expect(licitation_commission.errors.full_messages).to include "Membros da comissão de licitação deve ter ao menos um membro na equipe de apoio"
    end
  end
end

