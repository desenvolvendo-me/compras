# encoding: utf-8
require 'spec_helper'

feature "CapabilityAllocationDetails" do
  background do
    sign_in
  end

  scenario 'create a new capability_allocation_detail' do
    navigate 'Contabilidade > Orçamento > Recurso > Detalhamentos das Destinações de Recursos'

    click_link 'Criar Detalhamento das Destinações de Recursos'

    fill_in 'Descrição', :with => 'Educação'

    click_button 'Salvar'

    expect(page).to have_notice 'Detalhamento das Destinações de Recursos criado com sucesso.'

    click_link 'Educação'

    expect(page).to have_field 'Descrição', :with => 'Educação'
  end

  scenario 'validate uniqueness of description' do
    CapabilityAllocationDetail.make!(:educacao)

    navigate 'Contabilidade > Orçamento > Recurso > Detalhamentos das Destinações de Recursos'

    click_link 'Criar Detalhamento das Destinações de Recursos'

    fill_in 'Descrição', :with => 'Educação'

    click_button 'Salvar'

    expect(page).to have_content 'já está em uso'
  end

  scenario 'update an existent capability_allocation_detail' do
    CapabilityAllocationDetail.make!(:educacao)

    navigate 'Contabilidade > Orçamento > Recurso > Detalhamentos das Destinações de Recursos'

    click_link 'Educação'

    fill_in 'Descrição', :with => 'Reforma'

    click_button 'Salvar'

    expect(page).to have_notice 'Detalhamento das Destinações de Recursos editado com sucesso.'

    click_link 'Reforma'

    expect(page).to have_field 'Descrição', :with => 'Reforma'
  end

  scenario 'destroy an existent capability_allocation_detail' do
    CapabilityAllocationDetail.make!(:educacao)

    navigate 'Contabilidade > Orçamento > Recurso > Detalhamentos das Destinações de Recursos'

    click_link 'Educação'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice 'Detalhamento das Destinações de Recursos apagado com sucesso.'

    expect(page).to_not have_content 'Educação'
  end
end
