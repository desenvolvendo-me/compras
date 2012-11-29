# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/user_decorator'

describe UserDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have authenticable and login' do
      expect(described_class.header_attributes).to include :authenticable, :login
    end
  end
end
