User.blueprint(:sobrinho) do
  name          { 'Gabriel Sobrinho' }
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  profile       { Profile.make!(:manager) }
  authenticable { Employee.make!(:sobrinho) }
  confirmed_at  { 1.day.ago }
end

User.blueprint(:wenderson) do
  name          { 'Wenderson Malheiros' }
  email         { 'wenderson.malheiros@gmail.com' }
  login         { 'wenderson.malheiros'}
  password      { '123456' }
  profile       { Profile.make!(:manager) }
  authenticable { Employee.make!(:wenderson) }
  confirmed_at  { 1.day.ago }
end

User.blueprint(:sobrinho_as_admin) do
  name          { 'Gabriel Sobrinho' }
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  administrator { true }
  confirmed_at  { 1.day.ago }
end

User.blueprint(:sobrinho_as_admin_and_employee) do
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  profile       { Profile.make!(:manager) }
  administrator { true }
  authenticable { Employee.make!(:sobrinho) }
  confirmed_at  { 1.day.ago }
end

User.blueprint(:creditor_without_password) do
  email         { 'contato@sobrinhosa.com' }
  administrator { false }
  authenticable { Creditor.make!(:sobrinho_sa) }
end

User.blueprint(:creditor_with_password) do
  email         { 'contato@sobrinhosa.com' }
  login         { 'sobrinhosa' }
  password      { '123456' }
  administrator { false }
  authenticable { Creditor.make!(:sobrinho_sa) }
  confirmed_at  { 2.days.ago }
end

User.blueprint(:geraldi) do
  name          { 'Tiago Geraldi' }
  email         { 'tiago.geraldi@gmail.com' }
  password      { '123456' }
  login         { 'tiago.geraldi' }
  administrator { true }
  confirmed_at  { 1.day.ago }
end
