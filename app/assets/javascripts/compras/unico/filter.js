(function ($) {
  $(document).on("click", "div.actions a.filter", function () {
    var modal = $('<div class="ui-modal"><div class="ui-modal-loading"></div></div>');

    function setModalTitle() {
      var title = modal.find('h2');

      if (title.length) {
        modal.dialog('option', 'title', title.remove().html());
      }

      modal.find(':input:focusable:not([data-modal]):first').focus();
    }

    modal.on('dialogclose', function () {
      modal.remove();
    });

    modal.load(this.href, function(responseTxt, statusTxt, xhr){
      if(statusTxt == "success")
        setModalTitle()
    });

    modal.dialog({modal: true, width: 700, height: 450});

    return false;
  });
})(jQuery);
