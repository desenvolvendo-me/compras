(function ($) {
  $.widget('ui.modal', {
    _create: function () {
      this.hidden = $('#' + this.element.data('hidden-field-id'));
      this.element.focus(this._focus).keydown(this._keydown);
    },

    _init: function () {
      if (this.options.autoOpen) {
        this.open();

        delete this.options.autoOpen;
      }

      if (this.options.autoClear) {
        this.clear();

        delete this.options.autoClear;
      }
    },

    _focus: function (e) {
      if (this.value == '') {
        $(this).modal('open');
      }
    },

    _keydown: function (e) {
      if (e.metaKey || e.altKey || e.keyCode == $.ui.keyCode.SHIFT || e.keyCode == $.ui.keyCode.TAB) {
        return true;
      }

      switch (e.keyCode) {
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
          $(this).modal('clear');
          break;

        default:
          $(this).modal('open');
          break;
      }

      return false;
    },

    clear: function () {
      this.element.val('').trigger('change');
      this.hidden.val('').trigger('change');
    },

    open: function () {
      var element = this.element,
          hidden  = this.hidden,
          modal   = $('<div class="ui-modal"><div class="ui-modal-loading"></div></div>');

      modal.one('ajaxComplete', function () {
        var title = modal.find('h2');

        if (title.length) {
          modal.dialog('option', 'title', title.remove().html());
        }

        modal.find(':input:focusable:not([data-modal]):first').focus();
      });

      modal.delegate('tr[data-value]', 'click', function () {
        var tr = $(this);

        element.val(tr.attr('data-label')).trigger('change', {record: tr});
        hidden.val(tr.attr('data-value')).trigger('change', {record: tr});

        modal.dialog('close');
      });

      modal.delegate('a.cancel', 'click', function () {
        modal.dialog('close');
        return false;
      });

      modal.bind('dialogclose', function () {
        modal.remove();
      });

      modal.load(element.attr('data-modal-url')).dialog({modal: true, width: 700, height: 450});
    }
  });

  $('input[data-modal-url]').live('focus', function () {
    $(this).modal();
  });
})(jQuery);
