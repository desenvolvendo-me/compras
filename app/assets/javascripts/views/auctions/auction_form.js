(function (){
  var Views = Compras.Views;

  Views.AuctionForm = Views.RemoteForm.extend({

    initialize: function () {
      this.setElement($('form.auction'));

      this.eventName = 'auction';

    },

    setup: function () {
      if ($('form.auction').length > 0) {
        this.$submit = this.$("input[id$='auction_submit']");
        this._fixMozillaScroll();
      }
    },

    onSuccess: function(event, data) {
      debugger
      window.location.replace(Routes.auction_auctions)
    },

    onComplete: function () {

    },

    onError: function (event, data) {
      this.setSaveLabelSumbmit();

      var errors = $.parseJSON(data.responseText).errors;

      this.clearErrors();

      this.addErrors(errors);
    },
  });
})();
