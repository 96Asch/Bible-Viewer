import java.util.TreeSet;
import java.util.Collection;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class DictionaryTrie {

  private final static int ALPHABET_LEN = 26;
  private final static int NUM_LEN = 3;
  private TrieNode root;
  private String regex;

  public DictionaryTrie(final String regex) {
    root = new TrieNode();
    this.regex = regex;
  }

  public void addWord(final String word) {
    Pattern p = Pattern.compile(this.regex);
    Matcher m = p.matcher(word);
    if (m.find()) {
      root.addWord(word.toLowerCase());
    }
  }

  public ArrayList getWords(final String word) {
    TrieNode node = root;
    final String lower = word.toLowerCase();
    for (int i = 0; i < lower.length(); ++i) {
      node = node.getNode(lower.charAt(i));
      if (node == null) return new ArrayList();
    }
    return node.getWords(new StringBuffer());
  }
}

private class TrieNode { 
  private char character;
  private boolean isEnd;
  private boolean isLeaf;
  private TrieNode[] children;

  public TrieNode() {
    this.isEnd = false;
    this.isLeaf = true;
    this.children = new TrieNode[DictionaryTrie.ALPHABET_LEN + DictionaryTrie.NUM_LEN];
  }

  public TrieNode(final char character) {
    this();
    this.character = character;
  }

  public void addWord(final String word) {
    if (!word.isEmpty()) {
      char nextChar = word.charAt(0);
      int indexedChar;
      if (Character.isDigit(nextChar)) {        
        indexedChar = DictionaryTrie.ALPHABET_LEN + nextChar - '1';
      } else {
        indexedChar = nextChar - 'a';
      }
      this.isLeaf = false;
      if (children[indexedChar] == null) {
        children[indexedChar] = new TrieNode(nextChar);
      }
      if (word.length() > 1 ) {
        children[indexedChar].addWord(word.substring(1));
      } else {
        this.isEnd = true;
      }
    }
  }

  public ArrayList getWords(StringBuffer word) {
    ArrayList<String> list = new ArrayList();
    word.append(this.character);
    if (isEnd) {
      list.add(word.toString());
    }

    if (!isLeaf) {
      for (int i = 0; i < children.length; ++i) {
        if (children[i] != null) {
          list.addAll(children[i].getWords(word));
        }
      }
    }
    return list;
  }

  public TrieNode getNode(final char character) {
    int index = 0;
    if(Character.isDigit(character)) {
      index = DictionaryTrie.ALPHABET_LEN + character - '1';  
    }
    else {
      index = character - 'a';
    }
    return this.children[index];
  }

  public char getCharacter() {
    return character;
  }

  public boolean isEnd() {
    return isEnd;
  }

  public boolean isLeaf() {
    return isLeaf;
  }
}
