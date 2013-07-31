$(document).ready(function(){
  var quantityCreditors = $('tbody.contract_creditor_records > tr').length;

  disabledOrEnabledCreditor();

  $('form').on('change','#contract_creditor', function(event){
    quantityCreditors =+ 1;
    disabledOrEnabledCreditor();
  });

  $('form').on('change', '#contract_consortium_agreement', disabledOrEnabledCreditor);

  function disabledOrEnabledCreditor(){
    if(!$('#contract_consortium_agreement').is(':checked') && quantityCreditors > 0 ){
      $('#contract_creditor').attr('disabled','disabled');
    }else{
      $('#contract_creditor').removeAttr('disabled');
    }
  }
})
