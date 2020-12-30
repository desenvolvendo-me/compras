var $smartwizard = $("#auction_smartwizard");

function leaveStep(e, anchorObject, currentStepIndex, nextStep, stepDirection){

  if(!$("form:visible").data('changed')) return true;

  if(stepDirection === 'forward'){
    $smartwizard.smartWizard("loader", "show");
    $(".simple_form:visible").submit();
    $("form:visible").data('changed', false);
    return false
  }
}

function nextStep(){
  $smartwizard.smartWizard("loader", "hide");
  $smartwizard.off('leaveStep');
  $smartwizard.smartWizard("next");
  $smartwizard.on('leaveStep', leaveStep)
}

function errorOnSave(){
  $smartwizard.smartWizard("loader", "hide");
  alert('Houve um erro contate suporte');
}

//** Handle submit return of tab Dados dos Itens**//
$(document).on('ajax:complete', '.licitation_process', function(event, data, status, xhr) {
  if(status === 'success'){
    nextStep();
  }else{
    errorOnSave()
  }
});

$(document).on('click', '.btn-finish', function(){
  $(".simple_form:visible").submit();
  $(this).prop('disabled', false);
});

$(document).on('change', 'form:visible :input',function() {
  $(this).closest('form').data('changed', true);
});

$(function(){
  var enableNavigation = $('form.auction').attr('id').includes('edit');
  var btnFinish = $("<input type='submit'>").text('Salvar')
    .addClass('btn btn-info btn-finish')
    .attr('id', 'auction_submit');

  $smartwizard.smartWizard({
    selected: 0,
    theme: 'dots',
    justified: true,
    darkMode:false,
    autoAdjustHeight: false,
    cycleSteps: false,
    enableURLhash: true,
    toolbarSettings: {toolbarPosition: 'bottom',
      toolbarExtraButtons: [btnFinish]
    },
    transition: {
      animation: 'fade',
      speed: '400',
      easing:''
    },
    anchorSettings: {
      anchorClickable: true,
      enableAllAnchors: enableNavigation,
      markDoneStep: true,
      markAllPreviousStepsAsDone: true,
      removeDoneStepOnNavigateBack: true,
      enableAnchorOnDoneStep: true
    },
    lang: {
      next: 'Proximo',
      previous: 'Voltar'
    },
  });

  $smartwizard.smartWizard("reset");

  $smartwizard.on("leaveStep", leaveStep);

  $smartwizard.on("showStep", function(e, anchorObject, stepNumber, stepDirection) {
    if(stepNumber === 3){
      $('.btn-finish').show();
      $('.sw-btn-next').hide();
    }else{
      $('.btn-finish').hide();
      $('.sw-btn-next').show();
    }
  });
});

