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
      }
      this.$auction_item = new Views.AuctionItem();
      this.$auction_item.setup();
    },

    onSuccess: function(event, data) {
      $("form.auction").trigger('auction:afterSave');
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
