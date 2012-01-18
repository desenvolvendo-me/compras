# encoding: utf-8
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

    assert_equal current_path, '/401.html'
  end
end
