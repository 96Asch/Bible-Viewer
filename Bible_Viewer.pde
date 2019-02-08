import de.bezier.data.sql.*;
import g4p_controls.*;
import java.awt.Font;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

private PImage icon;
private SQLite db;
private Config config;

private TextBody header, body, error;
private GTextField field;

private DictionaryTrie trie;
private HashMap<String, String> translations;

private boolean moveForward;
private String currentTranslation;

void setup() {
  icon = loadImage("bible.png");
  size(1920, 1080);
  frameRate(60);
  db = new SQLite(this, "bible.db");
  config = new Config();
  moveForward = true;
  translations = new HashMap();
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

  field = new GTextField(this, 0, int(height*0.9), width, int(height*0.1));
  field.setFont(new Font("Dialog", Font.PLAIN, config.getFontSize()));
  field.setPromptText("Enter commands here, .h for help");
  field.addEventHandler(this, "handleTextField");
}

public void setupTrie() {
  trie = new DictionaryTrie("^[a-zA-z1-3]+$"); 
  String query = "SELECT sql FROM sqlite_master WHERE tbl_name = \'Books\' AND type = \'table\'";
  String wordQuery = "SELECT * FROM Books";
  String sqlCreate = "";
  ArrayList<String> langCol = new ArrayList();

  Pattern p = Pattern.compile(" (NAME\\S+) ");
  Matcher m;
  db.query(query);
  if (db.next()) {
    sqlCreate = db.getString("sql");
  }
  m = p.matcher(sqlCreate);
  while (m.find()) {
    langCol.add(m.group(1));
  }
  db.query(wordQuery);
  while (db.next()) {
    for(String s : langCol) {
      trie.addWord(db.getString(s));
    }
  }
  
  println(trie.getWords("Gen"));
}

public void setupTranslations() {
  String query = "SELECT * FROM Translation";
  db.query(query);
  while (db.next()) {
    translations.put(db.getString("ID"), db.getString("NAME"));
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
  header.draw();
  body.draw();
  error.draw();
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
      setVerse(text);
    }
  }
}

public void advanceVerse() {
  if (moveForward) {
    println("forward");
  } else {
    println("backward");
  }
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
      if (translations.containsKey(split[1])) {
        if (currentTranslation.equals(split[1])) {
          error.setText("Translation unchanged");
        } else {
          currentTranslation = split[1];
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
    String format = "%-30s%s%n";
    String translationList = String.format(format, "Translation", "Name");
    for (String k : translations.keySet()) {
      translationList += String.format(format, k, translations.get(k));
    }
    body.setText(translationList);
    break;
  case ">":
    moveForward = true;
    break;
  case "<":
    moveForward = false;
    break;
  default:
    error.setText("Error: Command not recognized, enter .h for a list of commands");
    break;
  }
}

public void setVerse(final String search) {
  body.setText(search);
}
