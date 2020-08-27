Department.blueprint(:departamento) do
  description { "Departamento" }
  purchasing_unit { PurchasingUnit.make!(:principal) }
  secretary { Secretary.make!(:secretaria) }

    # :department_people_attributes
end
