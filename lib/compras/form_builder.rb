# frozen_string_literal: true

module Compras
  class FormBuilder < SimpleForm::FormBuilder
    map_type :decimal, :float,          to: Compras::Inputs::DecimalInput
    map_type :string,  :tel,            to: Compras::Inputs::StringInput
    map_type :integer,                  to: Compras::Inputs::NumericInput
    map_type :modal,                    to: Compras::Inputs::ModalInput
    map_type :date,                     to: Compras::Inputs::DateInput
    map_type :time,                     to: Compras::Inputs::TimeInput
    map_type :has_and_belongs_to_many,  to: Compras::Inputs::HasAndBelongsToManyInput
    map_type :nested_form,              to: Compras::Inputs::NestedFormInput
    map_type :auto_complete,            to: Compras::Inputs::AutoCompleteInput
    map_type :fake,                     to: Compras::Inputs::FakeInput
    map_type :fake_select,              to: Compras::Inputs::FakeSelectInput
    map_type :nested_grid,              to: Compras::Inputs::NestedGridInput
    map_type :select2,                  to: Compras::Inputs::Select2Input

    def sanitized_object_name
      @sanitized_object_name ||= object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, '_').sub(/_$/, '')
    end

    def nested_identifier
      options[:index] || options[:child_index] || sanitized_object_name
    end

    def input(attribute_name, options = {}, &block)
      return super if options[:as]

      if reflection = find_association_reflection(attribute_name)
        options.reverse_merge!(as: find_association_type(reflection.association_class), reflection: reflection)

        if reflection.macro == :belongs_to
          attribute_name = reflection.options[:foreign_key] || :"#{reflection.name}_id"
          options.reverse_merge!(reflection: reflection)
        end
      elsif collection = find_enumeration_reflection(attribute_name)
        options.reverse_merge!(as: :select, collection: collection)
      end

      super
    end

    def find_association_type(association_class)
      if association_class == ActiveRecord::Associations::HasAndBelongsToManyAssociation || association_class == ActiveRecord::Associations::HasManyThroughAssociation
        :has_and_belongs_to_many
      elsif association_class == ActiveRecord::Associations::HasManyAssociation
        :nested_form
      else
        :modal
      end
    end

    def find_enumeration_reflection(attribute_name)
      if object.class.respond_to?(:enumerations)
        object.class.enumerations[attribute_name.to_sym]
      end
    end

    def submit_button(value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end

      options[:class]   = "#{options[:class].join(' ')} primary".strip
      options[:id]    ||= "#{object_name}_submit"

      submit(value, options)
    end

    def destroy_button(value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end

      value ||= template.translate('.destroy', cascade: true)

      options[:class]            = "#{options[:class].join(' ')} negative".strip
      options[:href]           ||= template.resource_path
      options[:method]         ||= :delete
      options[:id]             ||= "#{object_name}_destroy"
      options[:data]           ||= {}
      options[:data][:confirm] ||= template.translate('.are_you_sure', cascade: true, resource: object)

      template.link_to value, options.delete(:href), options
    end

    def print_button(value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end

      value ||= template.translate('.print', cascade: true)

      options[:class]   = "#{options[:class].join(' ')} primary".strip
      options[:href]  ||= template.resource_path
      options[:id]    ||= "#{object_name}_print"

      template.link_to value, options.delete(:href), options
    end

    def back_button(value = nil, options = {})
      if value.is_a?(Hash)
        options = value
        value = nil
      end

      value ||= template.translate('.back', cascade: true)

      options[:class]   = "#{options[:class].join(' ')} secondary".strip
      options[:href]  ||= template.smart_collection_path
      options[:id]    ||= "#{object_name}_back"

      template.link_to value, options.delete(:href), options
    end

    def errors(association)
      keys = self.object.errors.keys.select{ |key| key if key.to_s.include? "#{association}."}
      self.object.errors.to_hash.slice(*keys)
    end

  end
end
