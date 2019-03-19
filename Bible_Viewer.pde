import de.bezier.data.sql.*;
import g4p_controls.*;  
import java.awt.Font;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

private PImage icon;
private SQLite db;
private Config config;

private TextBody header, body, error, mode;
private GTextField field;

private DictionaryTrie trie;
private HashMap<String, Translation> translations;
private ArrayList<String> languageColumns;
private Book book;
private boolean moveForward;

private String currentTranslation;

private static final String FORWARD = ">>";
private static final String BACKWARD = "<<";
private static final String trieRegex = "^([1-3]?\\s?[a-zA-Z]+)";
private static final String verseRegex = trieRegex + "?(\\s?\\d{1,3})?\\s?(?::)?\\s?((?<=:)\\d{1,3})?";

void setup() {
  icon = loadImage("bible.png");
  size(1920, 1080);
  frameRate(60);
  db = new SQLite(this, "bible.db");
  config = new Config();
  moveForward = true;
  translations = new HashMap();
  languageColumns = new ArrayList();
  book = new Book();
  if (!db.connect()) {
    println("ERROR: Could not connect to database");
  }

  createGUI();
  setupTrie();
  setupTranslations();
}

void createGUI() {
  int x = int(width * 0.05);
  int w = int(width * 0.90);

  header = new TextBody(x, 0, w, int(height*0.2), config.getFontSize());
  header.setFont(config.getFont());
  header.setAlignX(CENTER);

  body = new TextBody(x, int(height*0.2), w, int(height*0.65), config.getFontSize());
  body.setFont(config.getFont());
  body.setAlignX(LEFT);

  error = new TextBody(x, int(height*0.85), w, int(height*0.5), int(config.getFontSize()/2));
  error.setFont(config.getFont());
  error.setAlignX(LEFT);
  error.setStyle(new Style() {
    public void setStyle(int x, int h, int w, int h) {
      fill(255, 0, 0);
    }
  });

  int y = int(height * 0.90);
  w = int(width * 0.95);

  mode = new TextBody(w, y, width-w, int(height * 0.10), int(config.getFontSize()));
  mode.setFont(config.getFont());
  mode.setAlignX(CENTER);
  mode.setStyle(new Style() {
    public void setStyle(int x, int y, int w, int h) {
      fill(200);
      rect(x, y, w, h);
      fill(0);
    }
  });
  mode.setText(FORWARD);

  field = new GTextField(this, 0, y, w, int(height*0.1));
  field.setFont(new Font("Dialog", Font.PLAIN, config.getFontSize()));
  field.setPromptText("Enter commands here, .h for help");
  field.addEventHandler(this, "handleTextField");
}

public void setupTrie() {
  trie = new DictionaryTrie(trieRegex); 
  String query = "SELECT sql FROM sqlite_master WHERE tbl_name = \'books\' AND type = \'table\'";
  String wordQuery = "SELECT * FROM books";
  String sqlCreate = "";

  Pattern p = Pattern.compile("\\s(NAME_\\S+)\\s");
  Matcher m;
  db.query(query);
  if (db.next()) {
    sqlCreate = db.getString("sql");
  }
  m = p.matcher(sqlCreate);
  while (m.find()) {
    languageColumns.add(m.group(1));
  }
  db.query(wordQuery);
  while (db.next()) {
    for (String s : languageColumns) {
      trie.addWord(db.getString(s));
    }
  }
}

private void setupTranslations() {
  currentTranslation = "";
  String query = "SELECT * FROM translation";
  db.query(query);
  while (db.next()) {
    translations.put(
      db.getString("ID"), 
      new Translation(db.getString("ID"), db.getString("NAME"), db.getString("LANGUAGE"))
      );
  }
}

void draw() {
  background(0);
  if (focused) {
    field.setFocus(true);
  }
  header.update(mouseX, mouseY);
  body.update(mouseX, mouseY);
  error.update(mouseX, mouseY);
  mode.update(mouseX, mouseY);
  header.draw();
  body.draw();
  error.draw();
  mode.draw();
}

public void handleTextField(GTextField textfield, GEvent event) { 
  switch(event) {
  case ENTERED:
    error.setText("");
    parseText(textfield.getText());
    textfield.setText("");
    break;
  default:
    break;
  }
}

public void parseText(final String text) {
  if (text.length() == 1 && text.charAt(0) == ' ') {
    advanceVerse();
  } else if (!text.isEmpty()) {
    Pattern p = Pattern.compile("[<>.]");
    Matcher m = p.matcher(text);
    if (m.find()) {
      handleCommands(text);
    } else {
      parseVerse(text);
    }
  }
}

public void advanceVerse() {
  Verse v;
  if (moveForward) {
    v = book.next();
  } else {
    v = book.previous();
  }
  displayVerse(v);
}

public void handleCommands(final String command) {
  String[] split = command.split(" ");
  switch(split[0]) {
  case ".h":
  case ".help":
    header.setText("Help");
    body.setText("Some help text here");
    break;
  case ".t":
  case ".trans":
  case ".translation":  
    if (split.length > 1) {
      if (translations.containsKey(split[1].toUpperCase())) {
        if (currentTranslation.equals(split[1])) {
          error.setText("Translation unchanged");
        } else {
          currentTranslation = split[1].toUpperCase();
          error.setText("Changed to: " + currentTranslation);
        }
      } else {
        error.setText("Translation not recognized, enter .tl to see the list of translations");
      }
    } else {
      error.setText("Argument missing");
    }
    break;
  case ".tl":
    header.setText("Translation list");
    String format = "%-30s %-30s %30s %n";
    String translationList = String.format(format, "Translation", "Name", "Language");
    for (String k : translations.keySet()) {
      Translation trans = translations.get(k);
      translationList += String.format(format, trans.getAbbreviation(), trans.getFullName(), trans.getLanguageCode());
    }
    body.setText(translationList);
    break;
  case ">":
    moveForward = true;
    mode.setText(FORWARD);
    advanceVerse();
    break;
  case "<":
    moveForward = false;
    mode.setText(BACKWARD);
    advanceVerse();
    break;
  default:
    error.setText("Error: Command not recognized, enter .h for a list of commands");
    break;
  }
}

private void parseVerse(final String search) {
  Matcher m = Pattern.compile(verseRegex).matcher(Util.formatString(search));
  String[] tokens = new String[m.groupCount()];
  if (m.matches()) {
    for (int i = 1; i <= m.groupCount(); ++i) {
      String token = m.group(i);
      tokens[i-1] = token;
    }
    verseHandler(tokens);
  } else {
    error.setText("Error: " + search +  " could not be read");
  }
}

private void verseHandler(String[] tokens) {
  int chapter = 1, verse = 1;
  if (tokens.length >= 3) {
    if (tokens[0] != null) {
      queryDBVerse(tokens[0]);
    }
    if (tokens[1] != null) {
      chapter = Integer.parseInt(tokens[1].trim());
    }
    if (tokens[2] != null) {
      verse = Integer.parseInt(tokens[2].trim());
    }
    displayVerse(book.get(chapter, verse));
  }
}

private void displayVerse(Verse v) {
  if (v != null) {
    header.setText(String.format("%s %s %d : %s", 
      currentTranslation, 
      book.getBookName(), 
      v.getChapter(), 
      v.getVerse()));

    body.setText(v.getText());
  }
}

private void queryDBVerse(final String input) {
  if (currentTranslation == null || currentTranslation.isEmpty()) {
    error.setText("No translation selected, use .t");
    return;
  }
  String currentLang = translations.get(currentTranslation).getLanguageCode();

  String query = "SELECT ID, T.BOOK_ID, T.CHAPTER, T.VERSE, T.TEXT,"
    + " B.NAME_" + currentLang  
    + " FROM " + currentTranslation.toLowerCase() + " AS T"
    + " INNER JOIN books AS B ON T.BOOK_ID = B.BOOK_ID"
    + " WHERE ";

  ArrayList<String> list = new ArrayList();

  trie.getWords(Util.formatString(input), list);

  if (!list.isEmpty()) {
    query += "NAME_" + currentLang + " = \'" + list.get(0) + "\'" ;
    db.query(query);
    boolean first = true;
    while (db.next()) {
      if (first) {
        book.setBook(db.getInt("BOOK_ID"), db.getString("NAME_" + currentLang));
        first = false;
      }
      book.insert(
        db.getInt("ID"), 
        db.getInt("CHAPTER"), 
        new Range(db.getString("VERSE")), 
        db.getString("TEXT")
        );
    }
  } else {
    error.setText("Error: Book " + book + "not found");
  }
}
