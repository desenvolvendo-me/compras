function parsePtBrFloat(value){
  return parseFloat(value.replace(/\./g,'').replace(',','.'));
}

function numberWithDelimiter(number, delimiter, separator){
  try {
    delimiter = delimiter || ".";
    separator = separator || ",";

    var parts = number.toFixed(2).split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);

    return parts.join(separator);
  } catch (e) {
    return number;
  }
}

function toFixedRoundDown(number) {
  // This return a 2 cases rounding down precised float.
  //
  // Return a float.
  //
  // Example:
  //
  //   (222.22 / 12).toFixed(2)
  //   => "18.52"
  //
  //   toFixedRoundDown(222.22 / 12)
  //   => 18.51
  return Math.floor(number * 100) / 100
}
