# require 'model_helper'
# require 'app/models/supply_request'
# require 'app/models/supply_request_item'
# require 'app/models/supply_order_requests'
# require 'app/models/supply_request_attendance'
#
# describe SupplyRequest do
#
#   context 'relationships' do
#     it { should belong_to :contract }
#     it { should belong_to :purchase_solicitation }
#     it { should belong_to :licitation_process }
#     it { should belong_to :creditor }
#     it { should belong_to :user }
#
#     it { should have_many(:items).class_name('SupplyRequestItem') }
#     it { should have_many(:supply_orders).class_name('SupplyOrderRequests') }
#     it { should have_many(:supply_request_attendances).class_name('SupplyRequestAttendance') }
#
#   end
#
#   context 'validations' do
#     it { should validate_presence_of :authorization_date }
#     it { should validate_presence_of :contract }
#     it { should validate_presence_of :purchase_solicitation }
#     it { should validate_presence_of :licitation_process }
#   end
#
# end
