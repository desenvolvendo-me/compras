require 'unit_helper'
require 'app/business/licitation_process_impugnment_updater'

describe LicitationProcessImpugnmentUpdater do
  it "should respond to update_licitation_process_date! method" do
    LicitationProcessImpugnmentUpdater.respond_to? :update_licitation_process_date!
  end
end
