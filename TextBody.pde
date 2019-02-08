class TextBody extends Node {


  protected String text; 
  protected int fontSize;
  protected String fontName;
  protected PFont font;
  protected int alignX;
  protected int alignY;

  TextBody(String _text, final int x, final int y, 
    final int w, final int h, final int _fontSize) 
  {
    super(x, y, w, h); 
    text = _text;
    fontSize = _fontSize;
    alignX = LEFT;
    alignY = BASELINE;
  }

  TextBody(String _text, final int x, final int y, 
    final int w, final int h, final int _fontSize, Style _style) 
  {
    this(_text, x, y, w, h, _fontSize);
    super.setStyle(_style);
  }

  TextBody(final int x, final int y, 
    final int w, final int h, final int _fontSize) 
  {
    this("", x, y, w, h, _fontSize);
  }


  @Override
    public void draw() {
    super.draw();
    if (font != null)
      textFont(font);
    strokeWeight(7);
    rect(x,y,w,h);
    textAlign(alignX, alignY);
    text(text, x, y, w, h); 
    textAlign(LEFT, BASELINE);
    noFill();
  }

  @Override
    public void update(int x, int y) {
    super.update(x, y);
  }

  public String getText() {
    return text;
  }

  public void setText(String _text) {
    text = _text;
  }

  public int getFontSize() {
    return fontSize;
  }

  public void setFontSize(int _fontSize) {
    fontSize = _fontSize;
  }

  public String getFont() {
    return fontName;
  }

  public void setFont(String _fontName) {
    fontName = _fontName; 
    font = createFont(fontName, fontSize, true);
  }

  public void setAlignX(int _alignX) {
    alignX = _alignX;
  }

  public void setAlignY(int _alignY) {
    alignY = _alignY;
  }
}
