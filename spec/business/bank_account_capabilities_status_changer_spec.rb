require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/bank_account_capabilities_status_changer'

describe BankAccountCapabilitiesStatusChanger do
  context "update date and status of capabilities" do
    let :capability1 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capability2 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capability3 do
      double(:status => nil, :date => nil, :inativation_date => nil)
    end

    let :capabilities do
      [capability1, capability2, capability3]
    end

    let :update_date do
      Date.new(2012, 1, 1)
    end

    let :bank_account do
      double(:capabilities => capabilities, :capabilities_without_status => capabilities, :first_capability_without_status => capability1)
    end

    it "first capability should receive active and current date" do
      capability1.should_receive(:activate!).with(update_date).and_return(true)

      capability2.should_receive(:inactivate!).with(update_date).and_return(true)

      capability3.should_receive(:inactivate!).with(update_date).and_return(true)

      BankAccountCapabilitiesStatusChanger.new(bank_account, update_date).change!
    end
  end
end
