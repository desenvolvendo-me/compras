# encoding: UTF-8
require 'spec_helper'

describe ExtraCredit do
  context 'uniqueness validations' do
    before { ExtraCredit.make!(:detran_2012) }

    it { should validate_uniqueness_of(:regulatory_act_id).with_message(:must_be_uniqueness_on_extra_credit) }

    it 'should validate uniqueness of budget_allocation' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      extra_credit.extra_credit_moviment_types << ExtraCreditMovimentType.make!(:adicionar_dotacao)
      extra_credit.extra_credit_moviment_types << ExtraCreditMovimentType.make!(:adicionar_dotacao)

      extra_credit.valid?

      extra_credit.errors[:extra_credit_moviment_types].should include('já está em uso')
    end

    it 'should validate uniqueness of capability' do
      extra_credit = ExtraCredit.make!(:detran_2012)
      extra_credit.extra_credit_moviment_types << ExtraCreditMovimentType.make!(:subtrair_do_excesso_arrecadado)
      extra_credit.extra_credit_moviment_types << ExtraCreditMovimentType.make!(:subtrair_do_excesso_arrecadado)

      extra_credit.valid?

      extra_credit.errors[:base].should include('já está em uso')
    end
  end
end