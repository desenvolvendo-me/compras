module Tributario
  module Inputs
    module MaskedInput

      def input_html_options
        options = super

        if has_mask?
          options['data-mask'] ||= mask
        end

        options
      end

      def has_mask?
        !!mask
      end

      def mask
        return unless has_validators?

        mask_validator = find_mask_validator or return
        mask_validator.mask_value_for(object)
      end

      def find_mask_validator
        find_validator(MaskValidator)
      end
    end
  end
end
