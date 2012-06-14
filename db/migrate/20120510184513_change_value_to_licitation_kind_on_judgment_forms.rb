class ChangeValueToLicitationKindOnJudgmentForms < ActiveRecord::Migration
  class JudgmentForm < ActiveRecord::Base
  end

  def up
    JudgmentForm.where { licitation_kind.eq('higher_discount') }.
                 update_all(:licitation_kind => 'higher_discount_on_lot')
  end

  def down
    JudgmentForm.where { licitation_kind.eq('higher_discount_on_lot') }.
                 update_all(:licitation_kind => 'higher_discount')
  end
end
