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
    expect(page).to have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').modal({autoClear: true}) }
  end

  def clear_mask(locator)
    expect(page).to have_field locator

    field = page.find_field(locator)
    page.execute_script %{ $('##{field[:id]}').val('') }
  end

  def create_roles(controllers)
    controllers.each do |controller|
      Role.make!(:general_role, :profile => current_user.profile, :controller => controller)
    end
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

  def fill_with_autocomplete(locator, options)
    within_autocomplete(locator, options) do
      within '.ui-menu-item' do
        page.find("a", :text => options.fetch(:with)).click
      end
    end
  end

  def within_autocomplete(locator, options)
    expect(page).to have_field locator

    field = page.find_field locator
    # Focus to enable the autocomplete
    page.execute_script %{ $('##{field[:id]}').focus() }
    # queries the source to get the efective records
    page.execute_script %{ $('##{field[:id]}').autocomplete("search", "#{options.fetch(:with)}") }
    # gets the widget and append to the view, since the plugin does not hide the menu anymore
    page.execute_script %{ $('##{field[:id]}').autocomplete("widget").show().appendTo( $('##{field[:id]}').parent() ) }
    expect(page).to have_css '.ui-autocomplete'

    within '.ui-autocomplete' do
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

  def navigate(path)
    first, second = path.split(/ > /, 2)

    click_link first

    return unless second

    within :xpath, ".//a[contains(., '#{first}')]/following-sibling::ul" do
      navigate second
    end
  end

  def click_record(record)
    begin
      within_records do
        page.find('td', :text => record).click
      end
    rescue Capybara::ElementNotFound
      raise Capybara::ElementNotFound, "Unable to find text '#{record}' on css 'td'"
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

  def within_dialog
    within :xpath, '(//div[contains(@class, "ui-dialog")])[last()]' do
      yield
    end
  end

  def close_dialog
    page.find(:xpath, '(//a[contains(@class, "ui-dialog-titlebar-close")])[last()]').click
  end
end

RSpec.configure do |config|
  config.include Helpers, :type => :request
end
