(function (){
  var Views = Compras.Views;

  Views.AuctionForm = Views.RemoteForm.extend({
    initialize: function () {
      this.setElement($('form.auction'));
debugger
      this.eventName = 'auction';
    },

    setup: function () {
      if ($('form.auction').length > 0) {
        this.$submit = this.$("input[id$='auction_submit']");
debugger
        this._fixMozillaScroll();
      }
    },

  });
})();
