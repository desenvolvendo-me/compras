$(document).ready(function() {

    $("#purchase_process_accreditation_has_power_of_attorney").prop( "checked", true );
    $("#purchase_process_accreditation_has_power_of_attorney").prop("disabled", true);

    function fillCreditorRepresentative(representatives) {

    $('#creditor_representative_id').empty();

    $('#creditor_representative_id').append(function() {
      return $("<option>").text('').val('');
    });

    _.each(representatives, function(representative) {
      $('#creditor_representative_id').append(function() {
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

  function getCreditorData(creditorId, representativeId) {
    var route = Routes.creditors;

    $.ajax({
      url: route + '?by_id=' + creditorId,
      dataType: 'json',
      success: function(creditors) {
        var creditor = creditors[0];
        fillCreditorRepresentative(creditor.representatives);
        $('#purchase_process_accreditation_personable_type').val(creditor.personable_type);
        $('#creditor_representative_id').val(representativeId);
      }
    });
  }

  $("#purchase_process_accreditation_creditor_id").on('change', function(event, creditor) {
    if (!creditor) {
      creditor = {};
    }

    $("#company_size_id").requiredField(creditor.is_company);
    $('#creditor_representative_id').val('');
    $('#creditor_representative_id').empty();
    $('#purchase_process_accreditation_personable_type').val(creditor.personable_type);
    $('#company_size_id').val(creditor.company_size_id)
                         .trigger('change');
    fillCreditorRepresentative(creditor.representatives);

    kindRequired(false);
    $('#creditor_representative_id').requiredField(true);
    $('#creditor_representative_id').addClass('required');
  });

  $("#creditor_representative_id").on("change", function() {
    kindRequired( !_.isEmpty($(this).val()) );
  });

  $("#purchase_process_accreditation_creditors_records").on('nestedGrid:afterAdd', function() {
    kindRequired(true);
  });

  $('#company_size_id').on('change', function() {
    var company_size = $(this).find('option:selected').text();

    $('#company_size').val(company_size);
  });

  $('#creditor_representative_id').on('change', function() {
    var representative = $(this).find('option:selected').text();

    if ( _.isEmpty(representative) ) {
      representative = 'Não possui representante';
    }

    $('#creditor_representative').val(representative);
  });

  $('.edit-nested-record').on('click', function() {
    var creditorId = $(this).closest('tr').find('.creditor_id').val(),
    representativeId = $(this).closest('tr').find('.creditor_representative_id').val();

    getCreditorData(creditorId, representativeId);
  });
});
