public class Book {

  private HashMap<Integer, Verse> verses;
  private String bookName;
  private int bookId;

  private int prev;
  private int current;
  private int next;


  public Book() {
    verses = new HashMap();
    bookName = "";
    prev = -1; 
    current = 0;
    next = -1;
  }

  public void setBook(final int bookId, final String bookName) {
    if (this.bookId == bookId) return;
    this.bookId = bookId;
    this.bookName = bookName;
    verses.clear();
  }

  public String getBookName() {
    return bookName;
  }

  public void insert(final int id, final int chapter, final Range verse, final String text) {
    Verse v = new Verse(chapter, verse, text);
    verses.put(id, v);
  }

  public boolean hasNext() {
    return next > 0;
  }
  
  public boolean hasPrevious() {
    return prev > 0;  
  }

  public Verse next() {
    if (next > 0) {
      prev = current;
      current = next;
      next = findNext();
      return verses.get(current);
    }
    return null;
  }
  
  public Verse previous() {
    if(prev > 0) {
      next = current;
      current = prev;
      prev = findPrevious();
      return verses.get(current);
    }
    return null;
  }

  private int findNext() {
    int id = current;
    int count = 0;
    Verse v = null;
    while (v == null) {
      if (count > 1000) {
        return -1;
      }
      ++count;
      v = verses.get(id + count);
    }
    return id + count;
  }

  private int findPrevious() {
    int id = current;
    int count = 0;
    Verse v = null;
    while (v == null) {
      if (count > 1000) {
        return -1;
      }
      ++count;
      v = verses.get(id - count);
    }
    return id - count;
  }

  public Verse get(final int chapter, final int verse) {
    int id = 1000000 * bookId + 1000 * chapter + verse;
    Verse v = verses.get(id);
    if (v != null) {
      current = id;
      next = findNext();
      prev = findPrevious();
    }
    return v;
  }
}
