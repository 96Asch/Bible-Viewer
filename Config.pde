public class Config {

  private final static String CONFIG_FILE = "bible_viewer.config";

  private final static String DB_ID = "db";
  private final static String H_ID = "height";
  private final static String W_ID = "width";
  private final static String FONT_ID = "font";
  private final static String FONT_SIZE_ID = "fontSize";

  private final static String DEFAULT_DB = "bible.db";
  private final static String DEFAULT_H = "1920";
  private final static String DEFAULT_W = "1020";
  private final static String DEFAULT_FONT = "HighlandGothicLightFLF.tff";
  private final static String DEFAULT_FONT_SIZE = "50";

  private String db = DEFAULT_DB;
  private int w = Integer.parseInt(DEFAULT_H);
  private int h = Integer.parseInt(DEFAULT_W);
  private String font = DEFAULT_FONT;
  private int fontSize = Integer.parseInt(DEFAULT_FONT_SIZE);

  public Config() {
    createDefault();
    read();
  }

  public void read() {
    BufferedReader in = createReader(dataPath(CONFIG_FILE));
    String line;
    try {
      while ((line = in.readLine()) != null) {
        parseLine(line);
      }
    }
    catch (IOException e) {
      println(e);
    }
    finally {
      if (in != null)
      try {
        in.close();
      }
      catch(IOException ex) {
        println(ex);
      }
    }
  }

  public String getDB() {
    return db;
  }

  public int getW() {
    return w;
  }

  public int getH() {
    return h;
  }

  public String getFont() {
    return font;
  }

  public int getFontSize() {
    return fontSize;
  }

  private void parseLine(final String line) {
    String[] split = line.split("=");
    switch(split[0]) {
    case DB_ID:
      db = split[1];
      break;
    case H_ID:
      h = Integer.parseInt(split[1]);
      break;
    case W_ID:
      w = Integer.parseInt(split[1]);
      break;
    case FONT_ID:
      font = split[1];
      break;
    case FONT_SIZE_ID:
      fontSize = Integer.parseInt(split[1]);
      break;
    }
  }

  private void write(PrintWriter writer, final String k, final String v) {
    writer.println(k + '=' + v);
  }

  private void createDefault() {
    File f = new File(dataPath(CONFIG_FILE));
    if (!f.exists()) {
      PrintWriter out = createWriter(dataPath(CONFIG_FILE));
      write(out, DB_ID, DEFAULT_DB);
      write(out, H_ID, DEFAULT_H);
      write(out, W_ID, DEFAULT_W);
      write(out, FONT_ID, DEFAULT_FONT);
      write(out, FONT_SIZE_ID, DEFAULT_FONT_SIZE);
      out.flush();
      out.close();
    }
  }
}
