(function () {
  var Views = Compras.Views;

  Views.Flashes = Backbone.View.extend({
    _style: {
      'z-index': 1000,
      position: 'fixed',
      top: '10px',
      width: "980px",
      left: (parseInt($(window).width(), 10) - 1000) / 2,
      oppacity: .9
    },

    initialize: function(options) {
      if (options === undefined || options.el === undefined) {
        this.setElement($("#flash"));
      }
    },

    renderAlert: function(text, timeOut) {
      this.render('alert', text, timeOut);
    },

    renderNotice: function(text, timeOut) {
      this.render('notice', text, timeOut);
    },

    fadeOut: function() {
      this.$el.find("div").fadeOut("fast", function() { $(this).remove(); });
    },

    render: function(flashType, text, timeOut) {
      if (!text) { return false; }

      var $element = $("<div class='" + flashType + "' style='display:none;'>" + text + "</div>");
      $element.css(this._style);

      this.$el.html($element);
      $element.fadeIn();

      if (timeOut) {
        var flash = this;

        setTimeout(function () { flash.fadeOut() }, timeOut);
      }
    }
  });
})();
