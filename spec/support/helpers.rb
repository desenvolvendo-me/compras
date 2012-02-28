module Helpers
  def self.included(receiver)
    receiver.let!(:current_user) do
      User.make!(:sobrinho_as_admin)
    end
  end

  def sign_in
    visit root_path

    fill_in 'Login', :with => current_user.login
    fill_in 'Senha', :with => current_user.password

    click_button 'Login'

    page.should have_notice 'Login efetuado com sucesso.'
  end

  def fill_mask(locator, options = {})
    msg = "cannot fill in, no text field with id, name, or label '#{locator}' found"
    raise "Must pass a hash containing 'with'" if not options.is_a?(Hash) or not options.has_key?(:with)

    field = find(:xpath, XPath::HTML.fillable_field(locator), :message => msg)
    page.execute_script %{document.getElementById('#{field[:id]}').value = '#{options[:with]}'}
  end

  def clear_modal(locator)
    page.should have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').modal('clear') }
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
    within_modal modal do
      fill_in options.fetch(:field, 'Nome'), :with => options.fetch(:with)

      yield if block_given?

      click_button 'Pesquisar'
      click_record options.fetch(:with)
    end
  end

  def within_modal(locator)
    page.should have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').modal({autoOpen: true}) }

    ignoring_scopes do
      within '.ui-dialog:nth-last-of-type(2)' do
        yield
      end
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

  def click_record(record)
    within_records do
      page.find('td', :text => record).click
    end
  end

  def within_tab(locator)
    within ".ui-tabs" do
      click_link locator

      within ".ui-tabs-panel:not(.ui-tabs-hide)" do
        yield
      end
    end
  end
end

RSpec.configure do |config|
  config.include Helpers, :type => :request
end
