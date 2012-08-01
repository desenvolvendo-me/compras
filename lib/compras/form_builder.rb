module Compras
  class FormBuilder < SimpleForm::FormBuilder
    map_type :decimal, :float, :to => Compras::Inputs::DecimalInput
    map_type :string,  :tel,   :to => Compras::Inputs::StringInput
    map_type :integer,         :to => Compras::Inputs::NumericInput
    map_type :modal,           :to => Compras::Inputs::ModalInput
    map_type :date,            :to => Compras::Inputs::DateInput
    map_type :time,            :to => Compras::Inputs::TimeInput

    def sanitized_object_name
      @sanitized_object_name ||= object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end

    def nested_identifier
      options[:index] || options[:child_index] || sanitized_object_name
    end

    def input(attribute_name, options = {}, &block)
      if reflection = find_association_reflection(attribute_name)
        if reflection.macro == :belongs_to
          attribute_name = reflection.options[:foreign_key] || :"#{reflection.name}_id"
        else
          raise "#{reflection.macro.inspect} associations are not supported by f.input"
        end

        options.reverse_merge!(:as => :modal, :reflection => reflection)
      elsif collection = find_enumeration_reflection(attribute_name)
        options.reverse_merge!(:as => :select, :collection => collection)
      end

      super
    end

    def find_enumeration_reflection(attribute_name)
      object.class.enumerations[attribute_name.to_sym] if object.class.respond_to?(:enumerations)
    end

    def submit_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      options[:class]   = "#{options[:class].join(" ")} primary".strip
      options[:id]    ||= "#{object_name}_submit"

      submit(value, options)
    end

    def destroy_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.destroy', :cascade => true, :resource => object)

      options[:class]            = "#{options[:class].join(" ")} negative".strip
      options[:href]           ||= template.resource_url
      options[:method]         ||= :delete
      options[:data]           ||= {}
      options[:data][:confirm] ||= template.translate('.are_you_sure', :cascade => true, :resource => object)
      options[:id]             ||= "#{object_name}_destroy"

      template.link_to value, options.delete(:href), options
    end

    def cancel_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.cancel', :cascade => true)

      options[:class]   = "#{options[:class].join(" ")} secondary".strip
      options[:href]  ||= template.smart_collection_url
      options[:id]    ||= "#{object_name}_cancel"

      template.link_to value, options.delete(:href), options
    end

    def print_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.print', :cascade => true)

      options[:class]   = "#{options[:class].join(" ")} primary".strip
      options[:href]  ||= template.resource_url
      options[:id]    ||= "#{object_name}_print"

      template.link_to value, options.delete(:href), options
    end
  end
end
