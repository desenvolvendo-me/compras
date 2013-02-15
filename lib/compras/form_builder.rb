module Compras
  class FormBuilder < SimpleForm::FormBuilder
    map_type :decimal, :float,          :to => Compras::Inputs::DecimalInput
    map_type :string,  :tel,            :to => Compras::Inputs::StringInput
    map_type :integer,                  :to => Compras::Inputs::NumericInput
    map_type :modal,                    :to => Compras::Inputs::ModalInput
    map_type :date,                     :to => Compras::Inputs::DateInput
    map_type :time,                     :to => Compras::Inputs::TimeInput
    map_type :has_and_belongs_to_many,  :to => Compras::Inputs::HasAndBelongsToManyInput
    map_type :nested_form,              :to => Compras::Inputs::NestedFormInput
    map_type :auto_complete,            :to => Compras::Inputs::AutoCompleteInput

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
      object.class.enumerations[attribute_name.to_sym] if object.class.respond_to?(:enumerations)
    end

    def enumeration(attribute_name, options = {}, &block)
      options[:as]         ||= :select
      options[:collection] ||= find_enumeration_reflection(attribute_name).to_a

      input(attribute_name, options, &block)
    end

    def association(association, options = {}, &block)
      association_class = find_association_reflection(association).try(:association_class)

      options[:as] ||= if association_class == ActiveRecord::Associations::HasManyAssociation
                         'nested_form'
                       else
                         'modal'
                       end

      super
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
      options[:href]           ||= template.resource_path
      options[:method]         ||= :delete
      options[:data]           ||= {}
      options[:data][:confirm] ||= template.translate('.are_you_sure', :cascade => true, :resource => object)
      options[:id]             ||= "#{object_name}_destroy"

      template.link_to value, options.delete(:href), options
    end

    def back_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.back', :cascade => true)

      options[:class]   = "#{options[:class].join(" ")} secondary".strip
      options[:href]  ||= template.smart_collection_path
      options[:id]    ||= "#{object_name}_back"

      template.link_to value, options.delete(:href), options
    end

    def print_button(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)

      value ||= template.translate('.print', :cascade => true)

      options[:class]   = "#{options[:class].join(" ")} primary".strip
      options[:href]  ||= template.resource_path
      options[:id]    ||= "#{object_name}_print"

      template.link_to value, options.delete(:href), options
    end
  end
end
