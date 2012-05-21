# encoding: utf-8
require 'spec_helper'

feature "AccreditedRepresentatives" do
  background do
    sign_in
  end

  scenario 'create a new accredited_representative' do
    Accreditation.make!(:credenciamento)
    individual = Individual.make!(:wenderson)
    provider = Provider.make!(:wenderson_sa)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      click_button 'Adicionar Representante'

      fill_modal 'Pessoa', :field => 'Nome', :with => 'Wenderson'
      fill_modal 'Fornecedor', :field => 'Número do CRC', :with => '456789'
      fill_in 'Cargo ou função', :with => 'Gerente'
    end

    click_button 'Salvar'

    page.should have_notice 'Credenciamento editado com sucesso.'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      page.should have_field 'Pessoa', :with => 'Wenderson Malheiros'
      page.should have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should have_field 'Cargo ou função', :with => 'Gerente'
      page.should have_field 'Número', :with => '1'
    end
  end

  scenario 'update an existent accredited_representative' do
    AccreditedRepresentative.make!(:wenderson)
    Individual.make(:sobrinho)
    Provider.make!(:sobrinho_sa)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      click_button 'Adicionar Representante'

      within '.representative:first' do
        fill_modal 'Pessoa', :with => 'Gabriel Sobrinho',  :field => 'Nome'
        fill_modal 'Fornecedor', :with => '123456', :field => 'Número do CRC'
        fill_in 'Cargo ou função', :with => 'Desenvolvedor'
      end
    end

    click_button 'Salvar'

    page.should have_notice 'Credenciamento editado com sucesso.'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      within '.representative:last' do
        page.should have_field 'Número', :with => '1'
        page.should have_field 'Pessoa', :with => 'Gabriel Sobrinho'
        page.should have_field 'Fornecedor', :with => 'Gabriel Sobrinho'
        page.should have_field 'Cargo ou função', :with => 'Desenvolvedor'
      end
    end
  end

  scenario 'destroy an existent accredited_representative' do
    AccreditedRepresentative.make!(:wenderson)

    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      click_button 'Remover'
    end

    click_button 'Salvar'

    page.should have_notice 'Credenciamento editado com sucesso.'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      page.should_not have_field 'Pessoa', :with => 'Wenderson Malheiros'
      page.should_not have_field 'Fornecedor', :with => 'Wenderson Malheiros'
      page.should_not have_field 'Cargo ou função', :with => 'Gerente'
      page.should_not have_field 'Número', :with => '1'
    end
  end

  scenario "should list in modal only providers that are in licitation process" do
    Accreditation.make!(:credenciamento)
    Provider.make!(:fornecedor_arame)
    
    click_link 'Processos'

    click_link 'Processos Administrativos'

    within_records do
      page.find('a').click
    end

    click_link 'Editar processo licitatório'

    click_link 'Editar credenciamento'

    within_tab 'Representantes' do
      click_button 'Adicionar Representante'

      within_modal 'Fornecedor' do
        click_button 'Pesquisar'

        page.should have_content '123456'
        page.should have_content '456789'
        page.should_not have_content '333333'
      end
    end
  end
end
