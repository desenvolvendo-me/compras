# encoding: utf-8
ActiveRecord::Base.transaction do
  [
    {
      :name => 'Adicionar dotação',
      :operation => MovimentTypeOperation::SUM,
      :character => MovimentTypeCharacter::BUDGET_ALLOCATION
    }, 
    {
      :name => 'Subtrair dotação',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::BUDGET_ALLOCATION
    },
    {
      :name => 'Subtrair do excesso arrecadado',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY
    },
    {
      :name => 'Subtrair de outros casos',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY
    },
    {
      :name => 'Adicionar em outros casos',
      :operation => MovimentTypeOperation::SUM,
      :character => MovimentTypeCharacter::CAPABILITY
    },
    {
      :name => 'Subtrair superávit financeiro',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY
    },
    {
      :name => 'Subtrair operações de crédito',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY
    },
    {
      :name => 'Subtrair convênio',
      :operation => MovimentTypeOperation::SUBTRACTION,
      :character => MovimentTypeCharacter::CAPABILITY
    },
  ].each do |object|
    MovimentType.create! object
  end
end
