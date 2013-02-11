# encoding: utf-8
require 'spec_helper'

describe AccountsHelper do
  describe '#edit_title' do
    it 'should returns the current user' do
      helper.should_receive(:current_user).and_return('Gabriel Sobrinho')

      expect(helper.edit_title).to eq 'Gabriel Sobrinho'
    end
  end
end
