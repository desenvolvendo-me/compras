require 'spec_helper'

describe 'devise/mailer/reset_password_instructions' do
  before do
    assign(:resource, user)

    view.stub(:edit_password_url).with(user, :reset_password_token => 'caefcdefca').and_return('http://example.com/users/password/edit?reset_password_token=caefcdefca')
  end

  let :user do
    double(:user, :email => 'gabriel.sobrinho@gmail.com', :reset_password_token => 'caefcdefca')
  end

  context 'body' do
    before do
      render
    end

    it 'should have user info' do
      rendered.should include 'gabriel.sobrinho@gmail.com'
    end

    it 'body should have link to confirm the account' do
      rendered.should include 'http://example.com/users/password/edit?reset_password_token=caefcdefca'
    end
  end
end
