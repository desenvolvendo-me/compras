require 'spec_helper'

feature "BankAccounts" do
  background do
    sign_in
  end

  scenario 'create, update and destroy a new bank_account' do
    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      expect(page).to have_field 'Status', disabled: true
      expect(page).to have_select 'Status', :selected => 'Ativo', disabled: true
      select 'Aplicação', :from => 'Tipo'
      fill_in 'Descrição', :with => 'IPTU'
      fill_modal 'Banco', :with => 'Itaú'

      within_modal 'Agência' do
        expect(page).to have_field 'Banco', :with => 'Itaú', disabled: true

        fill_in 'Nome', :with => 'Agência Itaú'
        click_button 'Pesquisar'

        click_record 'Agência Itaú'
      end
      expect(page).to have_field 'Número da agência', :with => '10009', disabled: true
      expect(page).to have_field 'Dígito da agência', :with => '1', disabled: true

      fill_in 'Número da conta corrente', :with => '1111113'
      fill_in 'Dígito da conta corrente', :with => '1'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Bancária criada com sucesso.'

    click_link '1111113'

    within_tab 'Principal' do
      expect(page).to have_select 'Status', :selected => 'Ativo'
      expect(page).to have_select 'Tipo', :selected => 'Aplicação'
      expect(page).to have_field 'Descrição', :with => 'IPTU'
      expect(page).to have_field 'Agência', :with => 'Agência Itaú'
      expect(page).to have_field 'Número da agência', :with => '10009', disabled: true
      expect(page).to have_field 'Dígito da agência', :with => '1', disabled: true
      expect(page).to have_field 'Número da conta corrente', :with => '1111113'
      expect(page).to have_field 'Dígito da conta corrente', :with => '1'
    end

    within_tab 'Principal' do
      fill_in 'Descrição', :with => 'IPTU'

      select 'Inativo', :from => 'Status'
      select 'Movimento', :from => 'Tipo'
      fill_in 'Número da conta corrente', :with => '1111114'
    end

    click_button 'Salvar'

    expect(page).to have_notice 'Conta Bancária editada com sucesso.'

    click_link '1111114'

    within_tab 'Principal' do
      expect(page).to have_select 'Status', :selected => 'Inativo'
      expect(page).to have_select 'Tipo', :selected => 'Movimento'
      expect(page).to have_field 'Descrição', :with => 'IPTU'
      expect(page).to have_field 'Número da conta corrente', :with => '1111114'
    end

    click_link 'Apagar'

    expect(page).to have_notice 'Conta Bancária apagada com sucesso.'

    expect(page).to_not have_content 'IPTU'
  end

  scenario 'when fill/clear agency should fill/clear related fields' do

    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Número da agência', :with => '10009', disabled: true
      expect(page).to have_field 'Dígito da agência', :with => '1', disabled: true
    end

    clear_modal 'Agência'

    within_tab 'Principal' do
      expect(page).to have_field 'Número da agência', :with => '', disabled: true
      expect(page).to have_field 'Dígito da agência', :with => '', disabled: true
    end
  end

  scenario 'when clear bank should clear agency too' do

    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Banco', :with => 'Itaú'
      fill_modal 'Agência', :with => 'Agência Itaú'

      clear_modal 'Banco'

      expect(page).to_not have_field 'Agência', :with => 'Agência Itaú'
      within_modal 'Agência' do
        expect(page).to_not have_field 'Banco', :with => 'Itaú'
      end
    end
  end

  scenario 'when select agency before bank, bank should fill bank' do

    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Agência', :with => 'Agência Itaú'

      expect(page).to have_field 'Banco', :with => 'Itaú'
    end
  end

  scenario 'when fill bank and submit form with errors should return with bank' do

    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    click_link 'Criar Conta Bancária'

    within_tab 'Principal' do
      fill_modal 'Banco', :with => 'Itaú'
    end

    click_button 'Salvar'

    within_tab 'Principal' do
      expect(page).to have_field 'Banco', :with => 'Itaú'
    end
  end

  scenario 'index with columns at the index' do
    BankAccount.make!(:itau_tributos)

    navigate 'Cadastro > Cadastrais > Bancos > Contas Bancárias'

    within_records do
      expect(page).to have_content 'Número da conta corrente'
      expect(page).to have_content 'Status'

      within 'tbody tr' do
        expect(page).to have_content '1111'
        expect(page).to have_content 'Ativo'
      end
    end
  end
end
