require 'spec_helper'

describe 'devise/mailer/confirmation_instructions' do
  before do
    assign(:resource, user)
    assign(:email, 'gabriel.sobrinho@gmail.com')

    view.stub(:confirmation_url).with(user, :confirmation_token => 'caefcdefca').and_return('http://example.com/users/confirm_account?confirmation_token=caefcdefca')
  end

  let :user do
    double(:user, :email => 'gabriel.sobrinho@gmail.com', :confirmation_token => 'caefcdefca')
  end

  context 'body' do
    before do
      render
    end

    it 'should have user info' do
      rendered.should include 'gabriel.sobrinho@gmail.com'
    end

    it 'body should have link to confirm the account' do
      rendered.should include 'http://example.com/users/confirm_account?confirmation_token=caefcdefca'
    end
  end
end
