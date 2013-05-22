class ContractAdditiveType < EnumerateIt::Base
  associate_values :extension_term,
                   :value_additions,
                   :value_decrease,
                   :readjustment,
                   :recomposition,
                   :others
end
