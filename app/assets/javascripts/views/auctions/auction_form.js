// (function (){
//   var Views = Compras.Views;
//
//   Views.AuctionForm = Views.RemoteForm.extend({
//     initialize: function () {
//       this.setElement($('form.auction'));
//
//       this.eventName = 'auction';
//     },
//
//     setup: function () {
//       this.$submit = $("#auction_submit");
//       this.$smart_wizard = $('#auction_smartwizard');
//       this.$auction_item = new Views.AuctionItem();
//       this.$auction_item.setup();
//     },
//
//     onSuccess: function(event, data) {
//       this.$submit = $("#auction_submit");
//       if(this.$submit.is(':visible')){
//         window.location.replace(Routes.auction_auctions)
//       }else{
//         this.$smart_wizard.smartWizard("next");
//       }
//     },
//
//     onComplete: function () {
//
//     },
//
//     onError: function (event, data) {
//       this.$submit = $("#auction_submit");
//       this.setSaveLabelSumbmit();
//
//       var errors = $.parseJSON(data.responseText).errors;
//
//       this.clearErrors();
//       this.addErrors(errors);
//     },
//
//     addErrors: function (errors) {
//       addErrorsToFields(errors, this.$el);
//       this.addGenericErrors(errors);
//     },
//   });
// })();
