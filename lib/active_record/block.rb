module ActiveRecord
  module Block
    # Block destroy and update just overwriting destroyable? and updateable?
    # methods
    #
    def self.included(base)
      base.extend(ClassMethods)

      base.load_cant_be_updated_validate
      base.load_cant_be_destroyed_callback
    end

    module ClassMethods
      def load_cant_be_updated_validate
        validate do
          if persisted? && !updateable?
            attribute_names.each do |attr|
              if send("#{attr}_changed?")
                errors.add(attr, :cant_be_updated)
              end
            end
          end
        end
      end

      def load_cant_be_destroyed_callback
        before_destroy :cant_be_destroyed, :if => lambda { !self.destroyable? }
      end
    end

    def destroyable?
      true
    end

    def updateable?
      true
    end

    private

    def cant_be_destroyed
      errors.add(:base, :cant_be_destroyed)
      false
    end
  end
end
