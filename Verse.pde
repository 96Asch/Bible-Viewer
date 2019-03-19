public class Verse {

  private int chapter;
  private Range verse;
  private String text;

  public Verse(final int chapter, final String verse, final String text) {
    this(chapter, new Range(verse), text);
  }

  public Verse(final int chapter, final Range verse, final String text) {
    this.chapter = chapter;
    this.verse = verse;
    this.text = text;
  }

  public int getChapter() {
    return chapter;
  }

  public Range getVerse() {
    return verse;
  }

  public String getText() {
    return text;
  }
}

private class Range {

  private final int begin;
  private final int end;

  public Range(final int r0, final int r1) {
    begin = r0;
    end = r1;
  }

  public Range(final String range) {
    String[] split = range.split("-");
    if (split.length > 1) {
      begin = Integer.parseInt(split[0]);
      end = Integer.parseInt(split[1]);
    } else {
      begin = end = Integer.parseInt(split[0]);
    }
  }
  
  public int getDelta() {
    return end - begin;  
  }

  public boolean isInRange(final int x) {
    return begin <= x && x <= end;
  }

  public int getBegin() {
    return begin;
  }

  public int getEnd() {
    return end;
  }

  @Override
    public String toString() {
    if (begin == end) {
      return String.format("%d", begin);
    } else {
      return String.format("%d - %d", begin, end);
    }
  }
}
