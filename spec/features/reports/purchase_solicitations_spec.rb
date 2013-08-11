require 'spec_helper'

feature 'Report::PurchaseSolicitations' do
  let :budget_structure_saude do
    double(:budget_structure_saude, id: 1, description: 'Saúde', to_s: '1 - Saúde')
  end

  let :budget_structure_educacao do
    double(:budget_structure_educacao, id: 2, description: 'Educação', to_s: '2 - Educação')
  end

  background do
    sign_in
  end

  scenario 'should show report' do
    BudgetStructure.stub(:find).with(1, params: {}).and_return budget_structure_saude
    BudgetStructure.stub(:find).with(2, params: {}).and_return budget_structure_educacao

    PurchaseSolicitation.make!(:reparo_liberado)
    PurchaseSolicitation.make!(:reparo)
    PurchaseSolicitation.make!(:reparo_office, budget_structure_id: 2)

    navigate 'Relatórios > Relatório de Solicitações Emitidas'

    click_button 'Filtrar'

    within_records do
      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content '1 - Saúde'
        expect(page).to have_content '01.01.00001 - Antivirus'
        expect(page).to have_content '6,00'
        expect(page).to have_content '1.200,00'
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content '2 - Educação'
        expect(page).to have_content '01.01.00002 - Office'
        expect(page).to have_content '3,00'
        expect(page).to have_content '600,00'
      end

      within 'tbody tr:nth-child(3)' do
        expect(page).to have_content '2 - Educação'
        expect(page).to have_content '02.02.00001 - Arame farpado'
        expect(page).to have_content '99,00'
        expect(page).to have_content '19.800,00'
      end
    end
  end
end
