require 'decorator_helper'
require 'app/decorators/<%= singular_name %>_decorator'

describe <%= class_name %>Decorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have <%= index_fields.join(', ') %>' do
    <% index_fields.each do |field| -%>
      expect(described_class.header_attributes).to include :<%= field %>
    <% end -%>
    end
  end
end
