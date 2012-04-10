class ExpenseNatureKind < EnumerateIt::Base
  associate_values :analytical, :synthetic, :both
end
