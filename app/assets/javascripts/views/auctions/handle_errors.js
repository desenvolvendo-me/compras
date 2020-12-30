//= require compras/errors.js

$(function(){
  var $el = $(".simple_form:visible");

  $(document).on('ajax:error', 'form', function(event, data, status, xhr) {
    var errors = $.parseJSON(data.responseText).errors;

    clearErrors();

    addErrors(errors);

    $smartwizard.smartWizard("loader", "hide");
  });

  function clearErrors(){
    clearBaseErrors($el);

    removeErrorFromField($("p[class$='field_with_errors']"));

    $("span[class$='error']").remove();
  }

  function addErrors(errors){
    addErrorsToFields(errors, $el);

    addGenericErrors(errors);
  }

  function addGenericErrors(){
    // montar um erro gennerico
  };
});
