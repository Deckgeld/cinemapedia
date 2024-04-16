import 'package:intl/intl.dart';

//Esta clase ayudara a serpara la logica de formateo de numeros, de esta forma si en un futuro cambia la forma de formatear los numeros solo se cambiara en un solo lugar
class HumanFormats {
  static String number(double number, [ int decimal = 0 ] ) {
    final fomatterNumber = NumberFormat.compactCurrency(
        decimalDigits: decimal, symbol: '', locale: 'en'
      ).format(number);

    return fomatterNumber;
  }


}
