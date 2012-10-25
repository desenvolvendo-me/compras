# encoding: utf-8
require 'spec_helper'

feature "TceSpecificationCapabilities" do
  background do
    sign_in
  end

  scenario 'try create with variable true and no agreements' do
    ApplicationCode.make!(:geral, :variable => true)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Principal' do
      within_modal 'Código da aplicação' do
        check 'Variável'
        click_button 'Pesquisar'
        click_record 'Geral'
      end
    end

    click_button 'Salvar'

    within_tab 'Convênios' do
      expect(page).to have_content 'deve ser informado os Convênios firmados com o Estado e/ou com o Governo Federal'
    end
  end

  scenario 'should not show inactive agreement at modal list' do
    Agreement.make!(:apoio_ao_turismo_inactive)
    Agreement.make!(:apoio_a_cultura)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Convênios' do
      within_modal 'Convênios' do
        click_button 'Pesquisar'

        within_records do
          expect(page).to_not have_content 'Apoio ao turismo'
        end
      end
    end
  end

  scenario 'agreement should be active if inactive occurrence was not be the last' do
    Agreement.make!(:apoio_ao_turismo_with_2_occurrences)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Convênios' do
      fill_modal 'Convênios', :with => 'Apoio ao turismo', :field => 'Objeto'

      expect(page).to have_content 'Ativo'
    end
  end

  scenario 'create a new tce_specification_capability' do
    CapabilitySource.make!(:imposto)
    ApplicationCode.make!(:geral)
    Agreement.make!(:apoio_ao_turismo)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Principal' do
      fill_in 'Descrição', :with => 'Ampliação do Posto de Saúde'
      fill_modal 'Fonte de recursos', :with => 'Imposto'
      fill_modal 'Código da aplicação', :with => 'Geral'
    end

    within_tab 'Convênios' do
      fill_modal 'Convênios', :with => 'Apoio ao turismo', :field => 'Objeto'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Especificação de Recursos do TCE criada com sucesso.'

    click_link 'Ampliação do Posto de Saúde'

    within_tab 'Principal' do
      expect(page).to have_field 'Descrição', :with => 'Ampliação do Posto de Saúde'
      expect(page).to have_field 'Fonte de recursos', :with => 'Imposto'
      expect(page).to have_field 'Especificação da fonte de recursos', :with => 'Especificação'
      expect(page).to have_field 'Código da aplicação', :with => 'Geral'
      expect(page).to have_field 'Especificação do código da aplicação', :with => 'Recursos próprios da entidade de livre aplicação'
    end

    within_tab 'Convênios' do
      expect(page).to have_content 'Convênio repassado'
      expect(page).to have_content 'Apoio ao turismo'
      expect(page).to have_content 'Ativo'
    end
  end

  scenario 'when fill/clear capability_source should fill/clear related field' do
    CapabilitySource.make!(:imposto)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Principal' do
      fill_modal 'Fonte de recursos', :with => 'Imposto'

      expect(page).to have_field 'Especificação da fonte de recursos', :with => 'Especificação'

      clear_modal 'Fonte de recursos'

      expect(page).to have_field 'Especificação da fonte de recursos', :with => ''
    end
  end

  scenario 'when fill/clear application_code should fill/clear related field' do
    ApplicationCode.make!(:geral)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Criar Especificação de Recursos do TCE'

    within_tab 'Principal' do
      fill_modal 'Código da aplicação', :with => 'Geral'

      expect(page).to have_field 'Especificação do código da aplicação', :with => 'Recursos próprios da entidade de livre aplicação'

      clear_modal 'Código da aplicação'

      expect(page).to have_field 'Especificação do código da aplicação', :with => ''
    end
  end

  scenario 'update an existent tce_specification_capability' do
    CapabilitySource.make!(:transferencia)
    ApplicationCode.make!(:transito)
    TceSpecificationCapability.make!(:ampliacao)
    Agreement.make!(:apoio_a_cultura)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Ampliação do Posto de Saúde'

    within_tab 'Principal' do
      fill_in 'Descrição *', :with => 'Reforma do Posto de Saúde'
      fill_modal 'Fonte de recursos', :with => 'Transferência'
      fill_modal 'Código da aplicação', :with => 'Trânsito'
    end

    within_tab 'Convênios' do
      click_button 'Remover'

      fill_modal 'Convênios', :with => 'Apoio a cultura', :field => 'Objeto'

      expect(page).to have_content 'Convênio recebido'
      expect(page).to have_content 'Apoio a cultura'
      expect(page).to have_content 'Ativo'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Especificação de Recursos do TCE editada com sucesso.'

    click_link 'Reforma do Posto de Saúde'

    within_tab 'Principal' do
      expect(page).to have_field 'Descrição *', :with => 'Reforma do Posto de Saúde'
      expect(page).to have_field 'Fonte de recursos', :with => 'Transferência'
      expect(page).to have_field 'Especificação da fonte de recursos', :with => 'Entre convênios'
      expect(page).to have_field 'Código da aplicação', :with => 'Trânsito'
      expect(page).to have_field 'Especificação do código da aplicação', :with => 'Recursos vinculados ao Trânsito'
    end
  end

  scenario 'destroy an existent tce_specification_capability' do
    TceSpecificationCapability.make!(:ampliacao)

    navigate 'Outros > Contabilidade > Orçamento > Recurso > Especificações de Recursos do TCE'

    click_link 'Ampliação do Posto de Saúde'

    click_link 'Apagar'

    expect(page).to have_notice 'Especificação de Recursos do TCE apagada com sucesso.'

    expect(page).to_not have_content 'Ampliação do Posto de Saúde'
  end
end
