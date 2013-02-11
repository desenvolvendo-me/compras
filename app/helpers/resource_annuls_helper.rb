# encoding: utf-8
module ResourceAnnulsHelper
  def new_title
    "Anular #{parent_model_name_translation} #{resource}"
  end

  def edit_title
    "Anulação da #{parent_model_name_translation} #{resource}"
  end

  private

  def parent_model_name_translation
    I18n.t("activerecord.models.#{parent_model_name}.one")
  end
end
