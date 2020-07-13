# require 'decorator_helper'
# require 'app/decorators/person_decorator'
#
# describe PersonDecorator do
#   context '#commercial_registration_date' do
#     context 'when have commercial_registration_date' do
#       before do
#         component.stub(:commercial_registration_date).and_return(nil)
#       end
#
#       it 'should be nil' do
#         expect(subject.commercial_registration_date).to be_nil
#       end
#     end
#
#     context 'when have commercial_registration_date' do
#       before do
#         component.stub(:commercial_registration_date).and_return(Date.new(2012, 12, 14))
#       end
#
#       it 'should localize' do
#         expect(subject.commercial_registration_date).to eq '14/12/2012'
#       end
#     end
#   end
#
#   context 'with attr_header' do
#       it 'should have headers' do
#         expect(described_class.headers?).to be_true
#       end
#
#       it 'should have name, id and cpf or cnpj' do
#         expect(described_class.header_attributes).to include :name
#         expect(described_class.header_attributes).to include :id
#         expect(described_class.header_attributes).to include :identity_document
#       end
#     end
# end
