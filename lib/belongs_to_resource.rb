# Atua como se fosse um belongs_to do active_record, mas ao invés de manter um
# relacionamento com um model do active_record, mantem um relacionamento com um
# model do active_resource.
#
# Ex:
#
# class BudgetStructure < ActiveResource::Base
#   ...
# end
#
# class Contract < ActiveRecord::Base
#   include BelongsToResource
#
#   belongs_to_resource :budget_structure
#   belongs_to_resource :budget_allocation
#
#   private
#
#   def budget_allocation_params
#     { includes: :expense_nature, methods: :amount }
#   end
# end
#
# c = Contract.last
#
# c.budget_structure_id
# => 3
# c.buget_allocation.expense_nature.id
# => 1
# c.buget_allocation.amount
# => 500.0
#
# c.budget_structure
# => consulta faz find na API
# => <#BudgetStructure teste>
#
# c.budget_structure = BudgetStucture.last
# c.budget_structure
# => não precisa fazer consulta na API e já atualiza o id
# => <#BudgetStructure novo>
#
# c.budget_structure(false)
# => não usa o cache, ou seja força o find na API
# => <#BudgetStructure novo>
#
# c.budget_structure_id = 34
# c.budget_structure
# => vai fazer a consulta na API pra atualizar o cache, porque mudou o id
# => <#BudgetStructure outro>
module BelongsToResource
  extend ActiveSupport::Concern

  module ClassMethods
    def belongs_to_resource(resource_name, options = {})
      resource_class = options.fetch(:resource_class) { resource_name.to_s.camelize.constantize }
      resource_id    = options.fetch(:resource_id, "#{resource_name}_id")

      create_reflection :belongs_to, resource_name, { foreign_key: resource_id }, self

      self.send(:class_eval, <<-eoruby, __FILE__, __LINE__ + 1)
        def #{resource_name}(use_cache = true)
          return unless #{resource_id}

          if use_cache
            #{resource_name}_cached
          else
            #{resource_class}.find(#{resource_id}, params: #{resource_name}_params)
          end
        end

        def #{resource_name}=(new_resource)
          self.#{resource_id}         = new_resource.try(:id)
          self.old_#{resource_id}     = #{resource_id}
          self.#{resource_name}_cache = new_resource
        end

        def #{resource_id}=(new_id)
          self.old_#{resource_id} = #{resource_id}

          if self.class.superclass <= ActiveResource::Base
            self.attributes[:#{resource_id}] = new_id
          else
            super
          end
        end

        private

        attr_accessor :old_#{resource_id}
        attr_accessor :#{resource_name}_cache

        def #{resource_name}_cached
          if #{resource_id}
            if old_#{resource_id} != #{resource_id}
              self.#{resource_name}_cache = #{resource_class}.find(#{resource_id}, params: #{resource_name}_params)
              self.old_#{resource_id} = #{resource_id}
            end
          else
            self.#{resource_name}_cache = nil
          end

          #{resource_name}_cache
        end

        def #{resource_name}_params
          {}
        end
      eoruby
    end
  end
end
