class Node {
  
  protected int x, y;
  protected int w, h;
  protected boolean inBounds;
  protected Style style;
  protected HoverEvent hover;

  Node(final int _x, final int _y, final int _w, final int _h) {
    setPosX(_x);
    setPosY(_y);
    setWidth(_w);
    setHeight(_h);
    inBounds = false;
    hover = null;
  }
  
  public void draw() {
    if(inBounds && hover != null)
      hover.onHover(x, y, w, h);
    else if(style != null) {
      style.setStyle(x, y, w, h);
    }
  }

  public void update(int x, int y) {
    if(isInBounds(x, y)) {
      inBounds = true;
    }
    else {
      inBounds = false; 
    }
  }
  
  public void setPosX(int _x) {
    x = _x < 0 ? width + _x : _x;
  }
  
  public void setPosY(int _y) {
    y = _y < 0 ? height + _y : _y; 
  }
  
  public void setWidth(int _width) {
    w = _width < 0 ? width + _width : _width; 
  }
  
  public void setHeight(int _height) {
    h = _height < 0 ? height + _height : _height; 
  }
  
  public void setOnHover(HoverEvent _hover) {
    hover = _hover;
  }
  
  public void setStyle(Style _style) {
    style = _style;
  }
  
  public void removeHover() {
    hover = null;
  }
  
  public void removeStyle() {
    style = null; 
  }
  
  public void onClick() {
    
  }

  public boolean isInBounds(int _x, int _y) {
    return (x < _x && _x < x + w)
            && (y < _y && _y < y + h);
  }
  
}
