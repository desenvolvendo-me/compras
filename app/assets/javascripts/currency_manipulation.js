function floatToPtBrString(value){
  return (value).toFixed(2).replace('.',',');
}

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
