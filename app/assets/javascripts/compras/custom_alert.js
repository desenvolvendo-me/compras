function custom_alert( message, title, buttons ) {
  if ( !title )
    title = 'Alerta';

  if ( !message )
    message = 'Nenhuma menssagem a ser mostrada.';

  if(typeof buttons === 'undefined')
    buttons = {};

  $("<div class='alert-dialog'></div>").html( message ).dialog({
    title: title,
    resizable: false,
    modal: true,
    dialogClass: 'custom-alert-dialog',
    buttons: buttons
  });
}