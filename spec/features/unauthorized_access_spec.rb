require 'spec_helper'

feature "UnauthorizedAccess" do
  let! :current_user do
    User.make!(:wenderson)
  end

  background do
    sign_in
  end

  scenario 'access a page without authorization' do
    visit users_path

    expect(page).to have_content 'Você não tem acesso a essa página!'
  end
end
