# encoding: utf-8
ActiveRecord::Base.transaction do
  [
    {
      :name => 'Adicionar dotação',
      :operation => MovimentTypeOperation::SUM,
      :character => MovimentTypeCharacter::BUDGET_ALLOCATION.
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair dotação',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::BUDGET_ALLOCATION,
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair do excesso arrecadado',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair de outros casos',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
    {
      :name => 'Adicionar em outros casos',
      :operation => MovimentTypeOperation::SUM,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair superávit financeiro',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair operações de crédito',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
    {
      :name => 'Subtrair convênio',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY,
      :source => Source::DEFAULT
    },
  ].each do |object|
    MovimentType.create! object
  end
end
