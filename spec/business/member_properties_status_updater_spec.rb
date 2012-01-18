require 'unit_helper'
require 'active_support/core_ext/object/blank'
require 'app/business/member_properties_status_updater'

describe MemberPropertiesStatusUpdater do
  let(:property) { double("Property") }

  it "should activated and deactivated properties" do
    property.should_receive(:deactivate_by_ids).with([12, 33, 65, 87, 92])
    property.should_receive(:activate_by_ids).with([14, 16, 22, 44])

    MemberPropertiesStatusUpdater.new(:property => property,
                                      :member_property_ids => [12, 33, 65, 87, 92],
                                      :old_member_property_ids => [12, 14, 16, 22, 44, 87]).update!
  end

  it "should deactivate properties" do
    property.should_receive(:deactivate_by_ids).with([14, 16, 22, 44])
    property.should_receive(:activate_by_ids).never

    MemberPropertiesStatusUpdater.new(:property => property,
                                      :member_property_ids => [14, 16, 22, 44]).update!
  end

  it "should activate properties" do
    property.should_receive(:deactivate_by_ids).never
    property.should_receive(:activate_by_ids).with([14, 16, 22, 44])

    MemberPropertiesStatusUpdater.new(:property => property,
                                      :member_property_ids => [],
                                      :old_member_property_ids => [14, 16, 22, 44]).update!
  end

  it "should not update the status of properties when no ids" do
    property.should_receive(:deactivate_by_ids).never
    property.should_receive(:activate_by_ids).never

    MemberPropertiesStatusUpdater.new(:property => property,
                                      :member_property_ids => [],
                                      :old_member_property_ids => []).update!
  end

  it "should not update the status of properties when the ids is the same" do
    property.should_receive(:deactivate_by_ids).never
    property.should_receive(:activate_by_ids).never

    MemberPropertiesStatusUpdater.new(:property => property,
                                      :member_property_ids => [12, 33, 65],
                                      :old_member_property_ids => [12, 33, 65]).update!
  end
end
