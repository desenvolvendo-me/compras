$(document).ready(function() {
  $("#company_size").requiredField(true);

  $("#purchase_process_accreditation_creditor_id").on('change', function(event, creditor){
    if (creditor) {
      $('#purchase_process_accreditation_personable_type').val(creditor.personable_type);
      $('#company_size').val(creditor.company_size_id);
      fillCreditorRepresentative(creditor.representatives);
    } else {
      $('#purchase_process_accreditation_personable_type').val('');
      $('#company_size').val('');
      $('#creditor_representative').val('');
      $('#creditor_representative').empty();
    }

    kindRequired(false);
  });

  $("#creditor_representative").on("change", function() {
    if ( $(this).val() ){
      kindRequired(true);
    } else {
      kindRequired(false);
    }
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
