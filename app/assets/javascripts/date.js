Date.parseUS = function (date) {
  var parts = date.split("-");
  return new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
};

Date.parseBR = function (date) {
  var parts = date.split("/");
  return new Date(parseInt(parts[2], 10), parseInt(parts[1], 10) - 1, parseInt(parts[0], 10));
};

Date.diffDatesInMonths = function(firstDate, secondDate) {
  var month = 1000*60*60*24*30;
  return Math.ceil(((firstDate.getTime() - secondDate.getTime()) / month) - 1);
}

Date.prototype.toStringBR = function () {
  var day = this.getDate().toString(),
      month = (this.getMonth() + 1).toString(),
      year = this.getFullYear().toString();

  if (day.length == 1) {
    day = "0" + day;
  }

  if (month.length == 1) {
    month = "0" + month;
  }

  return [day, month, year].join("/");
};

Date.prototype.sumDays = function (days) {
  var date = this;
  date.setDate(date.getDate() + days);
  return date;
};
