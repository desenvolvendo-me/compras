# frozen_string_literal: true

class AddSocietyKyndToPartner < ActiveRecord::Migration
  def change
    add_column :compras_partners, :society_kind, :string
  end
end
