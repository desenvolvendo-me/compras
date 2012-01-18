class MemberPropertiesStatusUpdater
  attr_accessor :member_property_ids, :old_member_property_ids, :property

  def initialize(options = {})
    self.member_property_ids = options.fetch(:member_property_ids)
    self.old_member_property_ids = options[:old_member_property_ids] || []
    self.property = options[:property] || Property
  end

  def update!
    property.deactivate_by_ids(member_property_ids) if update_property_ids?
    property.activate_by_ids(property_ids_to_activate) if property_ids_to_activate.present?
  end

  private

  def update_property_ids?
    member_property_ids.present? && (old_member_property_ids != member_property_ids)
  end

  def property_ids_to_activate
    old_member_property_ids - (old_member_property_ids & member_property_ids)
  end
end
