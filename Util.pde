public static class Util {

  public static String toUpper(final String str) {
    String upper;
    for (int i = 0; i < str.length(); ++i) {
      if (Character.isAlphabetic(str.charAt(i))) {  
        if (i == 0) {
          upper = Character.toUpperCase(str.charAt(0)) + str.substring(1);
        } else {
          upper = str.substring(0, i) + Character.toUpperCase(str.charAt(i)) + str.substring(i+1);
        }
        return upper;
      }
    }
    return "";
  }

  public static String toOneWhiteSpace(final String str) {
    String oneWhitespace = "";
    if (str.contains(" ")) {
      oneWhitespace = str.replaceAll("\\s+", " ");
    } else {
      oneWhitespace = insertWhiteSpace(str);
    }

    return oneWhitespace;
  }

  public static String insertWhiteSpace(final String str) {
    return str.replaceAll("(\\d)([a-zA-Z])","$1 $2");
  }
  
  public static String formatString(final String str) {
    return toOneWhiteSpace(str);
  }
}
