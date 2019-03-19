public class Translation {
 
  private String abbreviation;
  private String fullName;
  private String languageCode;
  
  public Translation(final String abbr, final String full, final String lang) {
    this.abbreviation = abbr;
    this.fullName = full;
    this.languageCode = lang;
  }
  
  public String getAbbreviation() {
    return this.abbreviation;  
  }
  
  public String getFullName() {
    return this.fullName;  
  }
  
  public String getLanguageCode() {
    return this.languageCode;  
  }
  
}
