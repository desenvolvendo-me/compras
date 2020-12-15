var $smartwizard = $("#auction_smartwizard");

function leaveStep(e, anchorObject, currentStepIndex, nextStep, stepDirection){
  if(stepDirection === 'forward'){
    $smartwizard.smartWizard("loader", "show");
    $(".simple_form:visible").submit();
    return false
  }
}

function nextStep(){
  $smartwizard.smartWizard("loader", "hide");
  $smartwizard.off('leaveStep');
  $smartwizard.smartWizard("next");
  $smartwizard.on('leaveStep', leaveStep)
}

function errorSave(){
  $smartwizard.smartWizard("loader", "hide");
  alert('Houve um erro contate suporte');
}

$(document).on('ajax:complete', '.licitation_process', function(event, data, status, xhr) {
  if(status === 'success'){
    nextStep();
  }else{
    errorSave()
  }
});

$(function(){
  var enableNavigation = $('form.auction').attr('id').includes('edit');
  var btnFinish = $("<input type='submit'>").text('Salvar')
    .addClass('btn btn-info btn-finish')
    .attr('id', 'auction_submit');

  $smartwizard.smartWizard({
    selected: 0, // Initial selected step, 0 = first step
    theme: 'dots', // theme for the wizard, related css need to include for other than default theme
    justified: true, // Nav menu justification. true/false
    darkMode:false, // Enable/disable Dark Mode if the theme supports. true/false
    autoAdjustHeight: false, // Automatically adjust content height
    cycleSteps: false, // Allows to cycle the navigation of steps
    enableURLhash: true, // Enable selection of the step based on url hash
    toolbarSettings: {toolbarPosition: 'bottom',
      toolbarExtraButtons: [btnFinish]
    },
    transition: {
      animation: 'fade', // Effect on navigation, none/fade/slide-horizontal/slide-vertical/slide-swing
      speed: '400', // Transion animation speed
      easing:'' // Transition animation easing. Not supported without a jQuery easing plugin
    },
    anchorSettings: {
      anchorClickable: true, // Enable/Disable anchor navigation
      enableAllAnchors: enableNavigation, // Activates all anchors clickable all times
      markDoneStep: true, // add done css
      markAllPreviousStepsAsDone: true, // When a step selected by url hash, all previous steps are marked done
      removeDoneStepOnNavigateBack: true, // While navigate back done step after active step will be cleared
      enableAnchorOnDoneStep: true // Enable/Disable the done steps navigation
    },
    lang: { // Language variables for button
      next: 'Proximo',
      previous: 'Voltar'
    },
  });

  $smartwizard.smartWizard("reset");

  $smartwizard.on("leaveStep", leaveStep);

  $smartwizard.on("showStep", function(e, anchorObject, stepNumber, stepDirection) {
    if(stepNumber === 3){
      $('.btn-finish').show();
    }else{
      $('.btn-finish').hide();
    }
  });
});

