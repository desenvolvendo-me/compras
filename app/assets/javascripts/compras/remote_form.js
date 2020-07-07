
(function () {
  var Views = Compras.Views;

  Views.RemoteForm = Backbone.View.extend({
    events: {
      "ajax:before": "onBefore",
      "ajax:complete": "onComplete",
      "ajax:error": "onError",
      "ajax:success": "onSuccess"
    },

    addErrors: function (errors) {
      debugger
      addErrorsToFields(errors, this.$el);

      this.addGenericErrors(errors);

      this.handleErrorOnTabs(errors, this.$el);
    },

    addGenericErrors: function (errors) {

    },

    clearErrors: function () {
      clearBaseErrors(this.$el);

      removeErrorFromField(this.$("p[class$='field_with_errors']"));

      this.$("span[class$='error']").remove();
    },

    formRemote: function () {
      return (this.$el.data("remote") == true);
    },

    handleErrorOnTabs: function(errors, el) {
      var field;

      _.each(errors, function(error_message, key) {
        if (key.indexOf('.') > 1) {
          var splittedKey = key.split('.');

          field = splittedKey[splittedKey.length - 1];

          return;
        }
      });

      var selectedTabContent = el.find('input[id*=' + field + ']').parents('div[role=tabpanel]');

      el.find('a[href=#' + $(selectedTabContent).attr('id') + ']').click();
    },

    onBefore: function () {
      debugger
      this.setSavingLabelSubmit();
    },

    onComplete: function () {
      this.setSaveLabelSumbmit();
      debugger
      window.opener.$(window.opener.document).trigger(this.eventName + ':ajax:complete');
    },

    onError: function (event, data) {
      debugger
      this.setSaveLabelSumbmit();

      var errors = $.parseJSON(data.responseText).errors;

      this.clearErrors();

      this.addErrors(errors);

      window.opener.$(window.opener.document).trigger(this.eventName + ':ajax:error', errors);
    },

    onSuccess: function(event, data) {
      debugger
      window.opener.$(window.opener.document).trigger(this.eventName + ':ajax:success', data);
    },

    setSavingLabelSubmit: function() {
      debugger
      this.$submit.val('Salvando...').attr('disabled', true);
    },

    setSaveLabelSumbmit: function() {
      debugger
      this.$submit.val('Salvar').attr('disabled', false);
    },

    _fixMozillaScroll: function () {
      debugger
      if ($.browser.mozilla && this.formRemote()) {
        $("#container").css({
          "overflow-y": "auto",
          "height": window.innerHeight
        });
      }
    }
  });
})();
