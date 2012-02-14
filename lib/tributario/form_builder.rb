module Tributario
  class FormBuilder < SimpleForm::FormBuilder
    map_type :decimal, :float, :to => Tributario::Inputs::DecimalInput
    map_type :string,  :tel,   :to => Tributario::Inputs::StringInput
    map_type :integer,         :to => Tributario::Inputs::NumericInput
    map_type :modal,           :to => Tributario::Inputs::ModalInput
    map_type :date,            :to => Tributario::Inputs::DateInput
    map_type :time,            :to => Tributario::Inputs::TimeInput

    def sanitized_object_name
      @sanitized_object_name ||= object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end

    def nested_identifier
      options[:index] || options[:child_index] || sanitized_object_name
    end

    def input(attribute_name, options = {}, &block)
      return super if options[:as]

      if find_association_reflection(attribute_name)
        association(attribute_name, options, &block)
      elsif find_enumeration_reflection(attribute_name)
        enumeration(attribute_name, options, &block)
      else
        super
      end
    end

    def find_enumeration_reflection(attribute_name)
      object.class.enumerations[attribute_name.to_sym]
    end

    def association(association, options = {}, &block)
      # FIXME: refactoring, code smell
      # do not fetch records using modal input
      options[:as] = options.fetch(:as, :modal) unless block_given?
      options[:collection] = [] if options[:as] == :modal

      super
    end

    def enumeration(attribute_name, options = {}, &block)
      options[:as]         ||= :select
      options[:collection] ||= find_enumeration_reflection(attribute_name).to_a

      input(attribute_name, options, &block)
    end

    def submit_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      options[:class]   = "#{options[:class]} primary".strip
      options[:id]    ||= "#{object_name}_submit"

      submit(value, options)
    end

    def destroy_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.destroy', :cascade => true, :resource => object)

      options[:class]     = "#{options[:class]} negative".strip
      options[:href]    ||= template.resource_url
      options[:method]  ||= :delete
      options[:confirm] ||= template.translate('.are_you_sure', :cascade => true, :resource => object)
      options[:id]      ||= "#{object_name}_destroy"

      template.link_to value, options.delete(:href), options
    end

    def cancel_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.cancel', :cascade => true)

      options[:class]   = "#{options[:class]} secondary".strip
      options[:href]  ||= template.smart_collection_url
      options[:id]    ||= "#{object_name}_cancel"

      template.link_to value, options.delete(:href), options
    end
  end
end
