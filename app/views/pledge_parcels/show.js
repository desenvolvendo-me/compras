$('<div><%= j render('pledge_parcels/show', :resource => resource.localized) %></div>').dialog({
    modal: true,
    width: 1024,
    height: 450,
    title: "Informações de:  <%= resource %>"
});
