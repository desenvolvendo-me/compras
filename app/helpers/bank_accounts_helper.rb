module BankAccountsHelper
  def sidebar_menu
    simple_menu do |m|
      m.banks
      m.agencies
    end
  end
end
