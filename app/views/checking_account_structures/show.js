$('<div><%= j render('checking_account_structures/show', :resource => resource.localized) %></div>').dialog({
    modal: true,
    width: 1024,
    height: 450,
    title: "Estrutura da Conta Corrente:  <%= resource.description %>"
});
