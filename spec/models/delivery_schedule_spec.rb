# encoding: utf-8
require 'model_helper'
require 'app/models/delivery_schedule'

describe DeliverySchedule do
  it { should belong_to :contract }

  it { should auto_increment(:sequence).by(:contract_id) }
end
