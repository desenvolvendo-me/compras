# encoding: utf-8

module AdministrativeProcessLiberationsHelper
  def new_title
    "Liberar Processo Administrativo #{resource.administrative_process}"
  end

  def edit_title
    "Liberação do Processo Administrativo #{resource.administrative_process}"
  end
end
