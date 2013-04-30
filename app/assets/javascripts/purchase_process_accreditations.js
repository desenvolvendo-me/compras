$(document).ready(function() {
  $("#purchase_process_accreditation_creditor_id").on('change', function(event, creditor){
    if (!creditor) {
      creditor = {}
    }

    $("#company_size").requiredField(creditor.is_company);
    $('#creditor_representative').val('');
    $('#creditor_representative').empty();
    $('#purchase_process_accreditation_personable_type').val(creditor.personable_type);
    $('#company_size').val(creditor.company_size_id);
    fillCreditorRepresentative(creditor.representatives);

    kindRequired(false);
  });

  $("#creditor_representative").on("change", function() {
    kindRequired( $(this).val() );
  });

  $("#accreditation-records").on('nestedGrid:afterAdd', function(){
    kindRequired(false);
  });

  function fillCreditorRepresentative(representatives) {
    $('#creditor_representative').append(function() {
      return $("<option>").text('').val('');
    });

    _.each(representatives, function(representative) {
      $('#creditor_representative').append(function() {
        return $("<option>").text(representative.name).val(representative.id);
      });
    });
  }

  function kindRequired(isRequired) {
    if ( isRequired ){
      $("#kind").requiredField(true);
      $("#kind").addClass('required');
    } else {
      $("#kind").requiredField(false);
      $("#kind").removeClass('required');
    }
  }
});
