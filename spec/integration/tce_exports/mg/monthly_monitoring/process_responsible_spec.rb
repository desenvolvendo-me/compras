require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::ProcessResponsibleGenerator, vcr: { cassette_name: 'integration/process_responsible' } do
  let(:customer) { double(:customer, domain: 'compras.dev', secret_token: '1234') }

  before do
    UnicoAPI::Consumer.set_customer customer
  end

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/RESPLIC.csv')
    end

    after do
      FileUtils.rm_f('tmp/RESPLIC.csv')
    end

    let :prefecture do
      Prefecture.make!(:belo_horizonte,
        address: Address.make!(:general))
    end

    let(:sobrinho) { Employee.make!(:sobrinho) }
    let(:wenderson) { Employee.make!(:wenderson) }
    let(:emissao_edital) { StageProcess.make!(:emissao_edital) }
    let(:processo_licitatorio) { LicitationProcess.make!(:processo_licitatorio) }
    let(:pregao) { LicitationProcess.make!(:pregao_presencial, process: 2) }
    let(:person_pedro) { Person.make!(:pedro_dos_santos) }
    let(:person_joao) { Person.make!(:joao_da_silva) }

    let(:comissao) do
      LicitationCommission.make!(:comissao,
        regulatory_act: RegulatoryAct.make!(:sopa,
          classification: RegulatoryActClassification::ORDINANCE,
          act_number: '1212',
          content: 'ementa'))
    end

    let(:comissao_pregao) do
      LicitationCommission.make!(:comissao_pregao_presencial,
        regulatory_act: RegulatoryAct.make!(:sopa,
          classification: RegulatoryActClassification::ORDINANCE,
          act_number: '1213',
          content: 'ementa 2'))
    end

    it "generates a CSV file with the required data" do
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      Employee.make!(:sobrinho, individual: person_pedro.personable, registration: "112323")
      Employee.make!(:sobrinho, individual: person_joao.personable, registration: "221212")

      JudgmentCommissionAdvice.make!(:parecer,
        licitation_process: processo_licitatorio,
        licitation_commission: comissao)

      JudgmentCommissionAdvice.make!(:parecer,
        licitation_process: pregao,
        licitation_commission: comissao_pregao)

      ProcessResponsible.create!(licitation_process_id: processo_licitatorio.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: sobrinho.id)

      ProcessResponsible.create!(licitation_process_id: pregao.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: wenderson.id)

      city = sobrinho.city
      city.tce_mg_code = 1
      city.save!

      city = wenderson.city
      city.tce_mg_code = 1
      city.save!

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        year: 2013)

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/RESPLIC.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98009001;2012;1;2;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com\n" +
                        "20;98;98009001;2012;1;2;1;1212;20032012;03012012;09012012;00314951334;Wenderson Malheiros;3;Gerente;1;Girassol;São Francisco;1;PR;33400500;3333333333;wenderson.malheiros@gmail.com\n" +
                        "10;98;98009001;2012;2;2;00314951334;Wenderson Malheiros;Girassol;São Francisco;1;PR;33400500;3333333333;wenderson.malheiros@gmail.com\n" +
                        "20;98;98009001;2012;2;1;1;1213;20032012;03012012;09012012;20653801440;Joao da Silva;6;Gerente;1;Girassol;São Francisco;1;PR;33400500;3333333333;joao.da.silva@gmail.com\n" +
                        "20;98;98009001;2012;2;1;1;1213;20032012;03012012;09012012;27056534147;Pedro dos Santos;2;Gerente;1;Girassol;São Francisco;1;PR;33400500;3333333333;pedro.dos.santos@gmail.com"
    end
  end
end
