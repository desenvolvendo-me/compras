# encoding: utf-8
require 'spec_helper'

feature "<%= controller_class_name %>" do
  background do
    sign_in
  end

  scenario 'create a new <%= singular_name %>' do
    <%- if associations? -%>
    make_dependencies!

    <%- end -%>
    click_link '<%= dashboard %>'

    click_link '<%= plural %>'

    click_link 'Criar <%= singular %>'

    <%- fields.each do |name, i18n| -%>
    fill_in '<%= i18n %>', :with => '<%= name %>'
    <%- end -%>

    click_button 'Salvar'

    expect(page).to have_notice '<%= singular %> criado com sucesso.'

    click_link '<%= fields.first.first %>'

    <%- fields.each do |name, i18n| -%>
    expect(page).to have_field '<%= i18n %>', :with => '<%= name %>'
    <%- end -%>
  end

  scenario 'update an existent <%= singular_name %>' do
    <%- if associations? -%>
    make_dependencies!

    <%- end -%>
    <%= class_name %>.make!(:example)

    click_link '<%= dashboard %>'

    click_link '<%= plural %>'

    click_link 'Example'

    <%- fields.each do |name, i18n| -%>
    fill_in '<%= i18n %>', :with => '<%= name %>'
    <%- end -%>

    click_button 'Salvar'

    expect(page).to have_notice '<%= singular %> editado com sucesso.'

    click_link '<%= fields.first.first %>'

    <%- fields.each do |name, i18n| -%>
    expect(page).to have_field '<%= i18n %>', :with => '<%= name %>'
    <%- end -%>
  end

  scenario 'destroy an existent <%= singular_name %>' do
    <%= class_name %>.make!(:example)
    click_link '<%= dashboard %>'

    click_link '<%= plural %>'

    click_link 'Example'

    click_link 'Apagar', :confirm => true

    expect(page).to have_notice '<%= singular %> apagado com sucesso.'

    <%- attributes.each do |attribute| -%>
    expect(page).to_not have_content '<%= attribute.name %>'
    <%- end -%>
  end
  <%- if associations? -%>

  def make_dependencies!
    <%- associations.each do |association| -%>
    <%= association.name.classify %>.make!(:example)
    <%- end -%>
  end
  <%- end -%>
end
