User.blueprint(:sobrinho) do
  name          { 'Gabriel Sobrinho' }
  email         { 'gabriel.sobrinho@gmail.com' }
  password      { '123456' }
  login         { 'gabriel.sobrinho' }
  administrator { true }
end

User.blueprint(:wenderson) do
  name     { 'Wenderson Malheiros' }
  email    { 'wenderson.malheiros@gmail.com' }
  login    { 'wenderson.malheiros'}
  password { '123456' }
  profile  { Profile.make!(:manager) }
end
