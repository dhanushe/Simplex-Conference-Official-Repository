class Parsing {
  static bool isValidName(String name) {
    // Split the full name into first and last names based on the space character.
    List<String> names = name.split(' ');

    // Check if there are exactly two names (first and last).
    if (names.length != 2) {
      return false;
    }

    // Check if both the first and last names start with capital letters.
    return startsWithCapital(names[0]) && startsWithCapital(names[1]);
  }

  static bool startsWithCapital(String word) {
    // Check if the first character is a capital letter.
    return word.isNotEmpty && word[0] == word[0].toUpperCase();
  }

  static String normalizeString(String input) {
    // Use a regular expression to remove non-alphabetical characters
    return input.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  static String removeEndOfImg(String link) {
    return link.substring(0, link.length - 13);
  }
}
