module Helpers
  def self.included(receiver)
    receiver.let!(:current_user) do
      user = User.make!(:sobrinho_as_admin)
      user.confirm!
      user
    end
  end

  def sign_in
    visit root_path

    fill_in 'Login', :with => current_user.login
    fill_in 'Senha', :with => current_user.password

    click_button 'Login'

    page.should have_notice 'Login efetuado com sucesso.'
  end

  def clear_modal(locator)
    page.should have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').modal({autoClear: true}) }
  end

  # Open a modal dialog and search the record
  #
  # ==== Examples
  #
  #     fill_modal "Estado', with: "São Paulo"
  #
  # Using a different field name:
  #
  #     fill_modal "Motivo", field: "Descrição", with: "Reclamação"
  #
  # Using a block to fill others fields:
  #
  #     fill_modal "Moeda", with: "Real" do
  #       check 'Moeda corrente'
  #     end
  #
  def fill_modal(modal, options = {})
    options[:fill] = true
    select_modal modal, options
  end

  def select_modal(modal, options = {})
    within_modal modal do
      fill_in options.fetch(:field, 'Nome'), :with => options.fetch(:with) if options.fetch(:fill, false)

      yield if block_given?

      click_button 'Pesquisar'

      click_record options.fetch(:with)
    end
  end

  def within_modal(locator)
    page.should have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').modal({autoOpen: true}) }

    within :xpath, '(//div[contains(@class, "ui-dialog")])[last()]' do
      yield
    end
  end

  def within_links
    within '.links' do
      yield
    end
  end

  def within_records
    within '.records' do
      yield
    end
  end

  def within_record
    within '.record' do
      yield
    end
  end

  def within_first_fieldset
    within 'fieldset:first' do
      yield
    end
  end

  def within_last_fieldset
    within 'fieldset:last' do
      yield
    end
  end

  def navigate_through(path)
    path.split('>').each do |link|
      click_link link.strip
    end
  end

  def click_record(record)
    within_records do
      page.find('td', :text => record).click
    end
  end

  def destroy_record(record, path)
    navigate_through "#{path} > #{record}"

    click_link "Apagar #{record}", :confirm => true
  end

  def within_tab(locator)
    within ".ui-tabs" do
      click_link locator

      within ".ui-tabs-panel:not(.ui-tabs-hide)" do
        yield
      end
    end
  end

  def navigate_through(path)
    path.split('>').each do |link|
      click_link link.strip
    end
  end
end

RSpec.configure do |config|
  config.include Helpers, :type => :request
end
