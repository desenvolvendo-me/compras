# encoding: utf-8
LicitationNotice.blueprint(:aviso_de_licitacao) do
  licitation_process { LicitationProcess.make!(:processo_licitatorio) }
  date { Date.current }
  number { 1 }
  observations { "A licitação começou." }
end