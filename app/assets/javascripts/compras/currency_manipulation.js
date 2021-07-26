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
function toFixedRoundDown(number) {
  return Math.floor(number * 100) / 100
}
