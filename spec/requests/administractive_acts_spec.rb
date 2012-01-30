# encoding: utf-8
require 'spec_helper'

feature "AdministractiveActs" do
  background do
    sign_in
  end

  scenario 'create a new administractive_act' do
    make_dependencies!

    click_link 'Cadastros Diversos'

    click_link 'Atos Administrativos'

    click_link 'Criar Ato Administrativo'

    within_tab "Principal" do
      fill_in 'Número', :with => '01'
      fill_modal 'Tipo', :with => 'Lei', :field => 'Nome'
      fill_in 'Natureza legal do texto jurídico', :with => 'natureza'
      fill_in 'Data da criação', :with => '01/01/2012'
      fill_in 'Data da publicação', :with => '02/01/2012'
      fill_in 'Data a vigorar', :with => '03/01/2012'
      fill_in 'Data do término', :with => '09/01/2012'
      fill_in 'Ementa', :with => 'conteudo'
    end

    within_tab "Complementar" do
      fill_in '% lei orçamentária', :with => '5,00'
      fill_in '% antecipação da receita', :with => '3,00'
      fill_in 'Valor autorizado da dívida', :with => '7000,00'
    end

    within_tab 'Fontes de divulgação' do
      fill_modal 'Fonte de divulgação', :with => 'Jornal Oficial do Município'
    end

    click_button 'Criar Ato Administrativo'

    page.should have_notice 'Ato Administrativo criado com sucesso.'

    click_link '01'

    within_tab 'Principal' do
      page.should have_field 'Número', :with => '01'
      page.should have_field 'Tipo', :with => 'Lei'
      page.should have_field 'Natureza legal do texto jurídico', :with => 'natureza'
      page.should have_field 'Data da criação', :with => '01/01/2012'
      page.should have_field 'Data da publicação', :with => '02/01/2012'
      page.should have_field 'Data a vigorar', :with => '03/01/2012'
      page.should have_field 'Data do término', :with => '09/01/2012'
      page.should have_field 'Ementa', :with => 'conteudo'
    end

    within_tab 'Complementar' do
      page.should have_field '% lei orçamentária', :with => '5,00'
      page.should have_field '% antecipação da receita', :with => '3,00'
      page.should have_field 'Valor autorizado da dívida', :with => '7000,00'
    end

    within_tab 'Fontes de divulgação' do
      page.should have_content 'Jornal Oficial do Município'
    end
  end

  scenario 'update an existent administractive_act' do
    make_dependencies!
    TypeOfAdministractiveAct.make!(:emenda)
    AdministractiveAct.make!(:sopa)
    DisseminationSource.make!(:jornal_bairro)

    click_link 'Cadastros Diversos'

    click_link 'Atos Administrativos'

    click_link '01'

    within_tab 'Principal' do
      fill_in 'Número', :with => '02'
      fill_modal 'Tipo', :with => 'Emenda constitucional', :field => 'Nome'
      fill_in 'Natureza legal do texto jurídico', :with => 'nova natureza'
      fill_in 'Data da criação', :with => '01/01/2013'
      fill_in 'Data da publicação', :with => '02/01/2013'
      fill_in 'Data a vigorar', :with => '03/01/2013'
      fill_in 'Data do término', :with => '09/01/2013'
      fill_in 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      fill_in '% lei orçamentária', :with => '15,00'
      fill_in '% antecipação da receita', :with => '13,00'
      fill_in 'Valor autorizado da dívida', :with => '17000,00'
    end

    within_tab 'Fontes de divulgação' do
      fill_modal 'Fonte de divulgação', :with => 'Jornal Oficial do Bairro'
    end

    click_button 'Atualizar Ato Administrativo'

    page.should have_notice 'Ato Administrativo editado com sucesso.'

    click_link '02'

    within_tab 'Principal' do
      page.should have_field 'Número', :with => '02'
      page.should have_field 'Tipo', :with => 'Emenda constitucional'
      page.should have_field 'Natureza legal do texto jurídico', :with => 'nova natureza'
      page.should have_field 'Data da criação', :with => '01/01/2013'
      page.should have_field 'Data da publicação', :with => '02/01/2013'
      page.should have_field 'Data a vigorar', :with => '03/01/2013'
      page.should have_field 'Data do término', :with => '09/01/2013'
      page.should have_field 'Ementa', :with => 'novo conteudo'
    end

    within_tab 'Complementar' do
      page.should have_field '% lei orçamentária', :with => '15,00'
      page.should have_field '% antecipação da receita', :with => '13,00'
      page.should have_field 'Valor autorizado da dívida', :with => '17000,00'
    end

    within_tab 'Fontes de divulgação' do
      page.should have_content 'Jornal Oficial do Bairro'
    end
  end

  scenario 'destroy an existent administractive_act' do
    AdministractiveAct.make!(:sopa)
    click_link 'Cadastros Diversos'

    click_link 'Atos Administrativos'

    click_link '01'

    click_link 'Apagar 01', :confirm => true

    page.should have_notice 'Ato Administrativo apagado com sucesso.'

    page.should_not have_link '01'
  end

  scenario 'should validate uniqueness of act_number' do
    AdministractiveAct.make!(:sopa)

    click_link 'Cadastros Diversos'

    click_link 'Atos Administrativos'

    click_link 'Criar Ato Administrativo'

    fill_in 'Número', :with => '01'

    click_button 'Criar Ato Administrativo'

    page.should have_content 'já está em uso'
  end

  scenario 'should validate uniqueness of content' do
    AdministractiveAct.make!(:sopa)

    click_link 'Cadastros Diversos'

    click_link 'Atos Administrativos'

    click_link 'Criar Ato Administrativo'

    fill_in 'Ementa', :with => 'conteudo'

    click_button 'Criar Ato Administrativo'

    page.should have_content 'já está em uso'
  end

  def make_dependencies!
    TypeOfAdministractiveAct.make!(:lei)
    DisseminationSource.make!(:jornal_municipal)
  end
end
