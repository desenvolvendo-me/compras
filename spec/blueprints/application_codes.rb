# encoding: utf-8
ApplicationCode.blueprint(:geral) do
  code { 110 }
  variable { false }
  name { "Geral" }
  specification { "Recursos próprios da entidade de livre aplicação" }
  source { Source::MANUAL }
end

ApplicationCode.blueprint(:transito) do
  code { 470 }
  variable { false }
  name { "Trânsito" }
  specification { "Recursos vinculados ao Trânsito" }
  source { Source::MANUAL }
end
