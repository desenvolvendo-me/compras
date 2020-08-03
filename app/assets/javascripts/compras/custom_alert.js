function custom_alert( message, title ) {
  if ( !title )
    title = 'Alerta';

  if ( !message )
    message = 'Nenhuma menssagem a ser mostrada.';

  $("<div class='alert-dialog'></div>").html( message ).dialog({
    title: title,
    resizable: false,
    modal: true,
  });
}