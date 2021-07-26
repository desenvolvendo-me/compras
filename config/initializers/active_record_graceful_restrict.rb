module ActiveRecord
  module GracefulRestrict
    def destroy
      super
    rescue ActiveRecord::DeleteRestrictionError
      errors.add(:base, :cant_be_destroyed)
      false
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActiveRecord::GracefulRestrict
end
