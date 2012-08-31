$('<div><%= j render('purchase_solicitation_item_groups/show', :resource => resource.localized) %></div>').dialog({
    modal: true,
    width: 1024,
    height: 450,
    title: "Solicitações de compra do agrupamento:  <%= resource.description %>"
});
