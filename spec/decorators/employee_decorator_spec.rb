# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/employee_decorator'

describe EmployeeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have individual, position, registration' do
      expect(described_class.header_attributes).to include :individual, :position, :registration
    end
  end
end
