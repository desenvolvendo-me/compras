# encoding: utf-8
require 'importer_helper'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'app/importers/account_plan_importer'

describe AccountPlanImporter do
  subject do
    described_class.new(null_repository, nature_balance, nature_information, surplus_indicator,
                        nature_balance_variation, movimentation_kind, checking_account_repository, config_importer)
  end

  let :checking_account_repository do
    double('CheckingAccountOfFiscalAccountRepository')
  end

  let :checking_account_object do
    double('CheckingAccountOfFiscalAccountObject', :id => 1)
  end

  let :nature_balance do
    double('NatureBalance')
  end

  let :nature_information do
    double('NatureInformation')
  end

  let :surplus_indicator do
    double('SurplusIndicator')
  end

  let :movimentation_kind do
    double('MovimentationKind')
  end

  let :nature_balance_variation do
    double('NatureBalanceVariation')
  end

  let :config_importer do
    double(:config_importer, :import! => config)
  end

  let :config do
    double(:config, :id => 5)
  end

  let :null_repository do
    double.as_null_object
  end

  it 'should import' do
    null_repository.should_receive(:transaction).and_yield

    nature_balance.should_receive(:value_for).
                  any_number_of_times.
                  with('DEBT').
                  and_return('debt')
    nature_balance.should_receive(:value_for).
                  any_number_of_times.
                  with('CREDIT').
                  and_return('credit')

    nature_information.should_receive(:value_for).
                      any_number_of_times.
                      with('PATRIMONIAL').
                      and_return('patrimonial')
    nature_information.should_receive(:value_for).
                      any_number_of_times.
                      with('BUDGET').
                      and_return('budget')
    nature_information.should_receive(:value_for).
                      any_number_of_times.
                      with('COMPENSATED').
                      and_return('compensated')

    surplus_indicator.should_receive(:value_for).
                     any_number_of_times.
                     with('FINANCIAL').
                     and_return('financial')
    surplus_indicator.should_receive(:value_for).
                     any_number_of_times.
                     with('PERMANENT').
                     and_return('permanent')

    nature_balance_variation.should_receive(:value_for).
                     any_number_of_times.
                     with('NOT_REVERSE_BALANCE').
                     and_return('not_reverse_balance')
    nature_balance_variation.should_receive(:value_for).
                     any_number_of_times.
                     with('REVERSE_BALANCE').
                     and_return('reverse_balance')

    movimentation_kind.should_receive(:value_for).
                      any_number_of_times.
                      with('BILATERAL').
                      and_return('bilateral')
    movimentation_kind.should_receive(:value_for).
                      any_number_of_times.
                      with('UNILATERAL_BORROWING').
                      and_return('unilateral_borrowing')
    movimentation_kind.should_receive(:value_for).
                      any_number_of_times.
                      with('UNILATERAL_CREDITOR').
                      and_return('unilateral_creditor')

    checking_account_repository.should_receive(:find_by_tce_code!).
                                any_number_of_times.
                                and_return(checking_account_object)

    null_repository.should_receive(:new).with(
      "checking_account" => "1.0.0.0.0.00.00",
      "title" => "ATIVO",
      "nature_balance" => nil,
      "bookkeeping" => false,
      "nature_information" => nil,
      "surplus_indicator" => nil,
      "nature_balance_variation" => nil,
      "movimentation_kind" => nil,
      "checking_account_of_fiscal_account_id" => nil,
      "detailing_required_opening" => false,
      "detailing_required_thirteenth" => false,
      "detailing_required_fourteenth" => false,
      "function" => "COMPREENDE OS RECURSOS CONTROLADOS POR UMA ENTIDADE COMO CONSEQUÊNCIA DE EVENTOS PASSADOS E DOS QUAIS SE ESPERA QUE FLUAM BENEFÍCIOS ECONÔMICOS OU POTENCIAL DE SERVIÇOS FUTUROS A UNIDADE.",
      "ends_at_twelfth_month" => false,
      "ends_at_thirteenth_month" => false,
      "ends_at_fourteenth_month" => false,
      "does_not_ends" => false,
      "account_plan_configuration_id" => config.id
    )

    null_repository.should_receive(:new).with(
      "checking_account" => "1.1.1.1.1.01.00",
      "title" => "CAIXA",
      "nature_balance" => "debt",
      "bookkeeping" => true,
      "nature_information" => "patrimonial",
      "surplus_indicator" => "financial",
      "nature_balance_variation" => "not_reverse_balance",
      "movimentation_kind" => "bilateral",
      "checking_account_of_fiscal_account_id" => 1,
      "detailing_required_opening" => true,
      "detailing_required_thirteenth" => false,
      "detailing_required_fourteenth" => false,
      "function" => "REGISTRA O SOMATORIO DE NUMERARIOS EM ESPECIE E OUTROS VALORES EM TESOURARIA.",
      "ends_at_twelfth_month" => false,
      "ends_at_thirteenth_month" => false,
      "ends_at_fourteenth_month" => false,
      "does_not_ends" => true,
      "account_plan_configuration_id" => config.id
    )

    null_repository.should_receive(:new).with(
      "checking_account" => "2.3.5.5.2.02.00",
      "title" => "RESERVAS DE LUCROS PARA EXPANSAO - DE EXERCICIOS ANTERIORES",
      "nature_balance" => "credit",
      "bookkeeping" => true,
      "nature_information" => "patrimonial",
      "surplus_indicator" => "permanent",
      "nature_balance_variation" => "not_reverse_balance",
      "movimentation_kind" => "bilateral",
      "checking_account_of_fiscal_account_id" => nil,
      "detailing_required_opening" => false,
      "detailing_required_thirteenth" => false,
      "detailing_required_fourteenth" => false,
      "function" => "REGISTRA AS RESERVAS CONSTITUIDAS COM PARTE DO LUCRO LIQUIDO DE EXERCICIOS ANTERIORES, COM O OBJETIVO DE ATENDER A PROJETOS DE INVESTIMENTO.",
      "ends_at_twelfth_month" => false,
      "ends_at_thirteenth_month" => false,
      "ends_at_fourteenth_month" => false,
      "does_not_ends" => true,
      "account_plan_configuration_id" => config.id
    )

    null_repository.should_receive(:new).with(
      "checking_account" => "8.9.4.3.2.00.00",
      "title" => "BAIXA DE ADIANTAMENTOS - VALOR UTILIZADO",
      "nature_balance" => "credit",
      "bookkeeping" => true,
      "nature_information" => "compensated",
      "surplus_indicator" => nil,
      "nature_balance_variation" => "not_reverse_balance",
      "movimentation_kind" => "bilateral",
      "checking_account_of_fiscal_account_id" => 1,
      "detailing_required_opening" => false,
      "detailing_required_thirteenth" => true,
      "detailing_required_fourteenth" => true,
      "function" => "REGISTRA O VALOR UTILIZADO PELO SERVIDOR  RESPONSÁVEL, PARA  ATENDER DESPESAS QUE NÃO POSSAM SUBORDINAR-SE AO PROCESSO NORMAL DE APLICAÇÃO, PELA SUA PRESTAÇÃO DE CONTAS.  " ,
      "ends_at_twelfth_month" => false,
      "ends_at_thirteenth_month" => true,
      "ends_at_fourteenth_month" => false,
      "does_not_ends" => false,
      "account_plan_configuration_id" => config.id
    )

    null_repository.should_receive(:new).with(
      "checking_account" => "8.9.4.6.2.04.00",
      "title" => "OUTROS CONVÊNIOS RECEBIDOS QUITADOS ",
      "nature_balance" => "credit",
      "bookkeeping" => true,
      "nature_information" => "compensated",
      "surplus_indicator" => nil,
      "nature_balance_variation" => "not_reverse_balance",
      "movimentation_kind" => "bilateral",
      "checking_account_of_fiscal_account_id" => 1,
      "detailing_required_opening" => false,
      "detailing_required_thirteenth" => true,
      "detailing_required_fourteenth" => true,
      "function" => "REGISTRA O VALOR DA PRESTAÇÃO DE CONTAS DA ENTIDADE POR VALORES RECEBIDOS - QUITAÇÃO.",
      "ends_at_twelfth_month" => false,
      "ends_at_thirteenth_month" => true,
      "ends_at_fourteenth_month" => false,
      "does_not_ends" => false,
      "account_plan_configuration_id" => config.id
    )

    subject.import!
  end
end
