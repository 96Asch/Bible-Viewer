public class Verse {
 
  private int id;
  private String book;
  private int chapter;
  private String verse;
  private String text;
  
  public Verse(final int id, final String book, final int chapter, final String verse, final String text) {
    this.id = id;
    this.book = book;
    this.chapter = chapter;
    this.verse = verse;
    this.text = text;
  }
  
  public int getId() {
    return id;  
  }
  
  public String getBook() {
    return book;  
  }
  
  public int getChapter() {
    return chapter;  
  }
  
  public String getVerse() {
    return verse;  
  }
  
  public String getText() {
    return text;  
  }
  
}
