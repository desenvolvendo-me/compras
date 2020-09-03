$(document).ready(function() {
  var $company_size_id = $("#accreditation_creditors  [name$='[company_size_id]']"),
      $representative = $("#accreditation_creditors [name$='[creditor_representative]']");

  $("[name$='[has_power_of_attorney]']")
    .prop( "checked", true )
    .prop("disabled", true);


  function kindRequired(isRequired) {
    var $kind = $("#accreditation_creditors [name$='[kind]']");
    if ( isRequired ){
      $kind.requiredField(true);
      $kind.addClass('required');
    } else {
      $kind.requiredField(false);
      $kind.removeClass('required');
    }
  }

  function getCreditorData(creditorId) {
    var route = Routes.creditors;

    $.ajax({
      url: route + '?by_id=' + creditorId,
      dataType: 'json',
      success: function(creditors) {
        var creditor = creditors[0];
        $representative.val(creditor.creditor_representative);
        $("[name$='[personable_type]']").val(creditor.personable_type);
      }
    });
  }

  $("#accreditation_creditors [name$='[creditor_id]']").on('change', function(event, creditor) {
    if (!creditor) {
      creditor = {};
    }

    $company_size_id.requiredField(creditor.is_company);
    $representative.val('');
    $representative.empty();
    $("[name$='[personable_type]']").val(creditor.personable_type);
    $company_size_id.val(creditor.company_size_id)
                         .trigger('change');

    if(creditor.creditor_representative){
      $representative.val(creditor.creditor_representative).trigger('change');
    }else{
      $representative.val('Não possui representante');
    }


    $company_size_id.requiredField(true);
  });

  $representative.on("change", function() {
    kindRequired( !_.isEmpty($(this).val()) );
  });

  $("#purchase_process_accreditation_creditors_records").on('nestedGrid:afterAdd', function() {
    kindRequired(true);
  });

  $company_size_id.on('change', function() {
    var company_size = $(this).find('option:selected').text();

    $('#company_size').val(company_size);
  });


  $('.edit-nested-record').on('click', function() {
    var creditorId = $(this).closest('tr').find('.creditor_id').val();

    getCreditorData(creditorId);
  });
});
