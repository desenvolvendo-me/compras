require 'spec_helper'

feature "MenuCache" do
  let! :current_user do
    User.make!(:wenderson)
  end

  background do
    sign_in
  end

  scenario 'should menu cache when change profile user' do
    visit profiles_path

    expect(page).to have_content 'Você não tem acesso a essa página!'

    current_user.administrator = true
    current_user.save!

    visit profiles_path
    expect(page).to_not have_content 'Você não tem acesso a essa página!'
  end
end
