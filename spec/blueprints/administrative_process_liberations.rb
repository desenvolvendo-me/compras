AdministrativeProcessLiberation.blueprint(:liberacao) do
  employee { Employee.make!(:sobrinho) }
  date { Date.new(2012, 02, 01) }
end
