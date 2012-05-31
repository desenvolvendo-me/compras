User.blueprint(:sobrinho) do
  name          { 'Gabriel Sobrinho' }
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  profile       { Profile.make!(:manager) }
  authenticable { Employee.make!(:sobrinho) }
end

User.blueprint(:wenderson) do
  name          { 'Wenderson Malheiros' }
  email         { 'wenderson.malheiros@gmail.com' }
  login         { 'wenderson.malheiros'}
  password      { '123456' }
  profile       { Profile.make!(:manager) }
  authenticable { Employee.make!(:wenderson) }
end

User.blueprint(:sobrinho_as_admin) do
  name          { 'Gabriel Sobrinho' }
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  administrator { true }
end

User.blueprint(:sobrinho_as_admin_and_employee) do
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  profile       { Profile.make!(:manager) }
  administrator { true }
  authenticable { Employee.make!(:sobrinho) }
end

User.blueprint(:provider_without_password) do
  email         { 'contato@sobrinhosa.com' }
  login         { 'sobrinhosa' }
  administrator { false }
  authenticable { Provider.make!(:sobrinho_sa) }
end
