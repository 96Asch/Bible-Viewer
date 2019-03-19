import java.util.TreeSet;
import java.util.Collection;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class DictionaryTrie {

  private final static int ALPHABET_LEN = 26;
  private final static int NUM_LEN = 3;
  private final static int SP_LEN = 1;
  private TrieNode root;
  private Pattern p;

  public DictionaryTrie(final String regex) {
    root = new TrieNode();
    p = Pattern.compile(regex);
  }

  public void addWord(final String word) {
    Matcher m = p.matcher(word);
    if (m.find()) {
      root.addWord(word.toLowerCase().trim());
    }
    else {
      println("Error: " + word + " rejected by the regex");  
    }
  }

  public void getWords(final String word, ArrayList<String> list) {
    Matcher m = p.matcher(word);
    if (m.find()) {
      if (list != null) {
        list.clear();
        TrieNode node = root, prev;
        final String lower = word.toLowerCase().trim();
        int prefixLength = 0;
        for (prefixLength = 0; prefixLength < lower.length(); ++prefixLength) {
          prev = node;
          node = node.getNode(lower.charAt(prefixLength));
          if (node == null) {
            if (prev != null) {
              node = prev;
              break;
            }
            return;
          }
        }
        node.getWords(word.substring(0, --prefixLength), list);
      }
    }
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
    this.children = new TrieNode[DictionaryTrie.ALPHABET_LEN
      + DictionaryTrie.NUM_LEN
      + DictionaryTrie.SP_LEN];
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
      } else if (Character.isWhitespace(nextChar)) {
        indexedChar = DictionaryTrie.ALPHABET_LEN + DictionaryTrie.NUM_LEN;
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
        children[indexedChar].setEnd(true);
      }
    }
  }

  public void getWords(String word, ArrayList<String> list) {
    if (isEnd()) {
      list.add(Util.toUpper(word + getCharacter()));
    }

    if (!isLeaf()) {
      for (int i = 0; i < children.length; ++i) {
        if (children[i] != null) {
          children[i].getWords(word + getCharacter(), list);
        }
      }
    }
  }

  public TrieNode getNode(final char character) {
    int indexedChar = 0;
    if (Character.isDigit(character)) { 
      indexedChar = DictionaryTrie.ALPHABET_LEN + character - '1';
    } else if (Character.isWhitespace(character)) {
      indexedChar = DictionaryTrie.ALPHABET_LEN + DictionaryTrie.NUM_LEN;
    } else {
      indexedChar = character - 'a';
    }
    return this.children[indexedChar];
  }

  public char getCharacter() {
    return character;
  }

  public boolean isEnd() {
    return isEnd;
  }

  public void setEnd(final boolean end) {
    isEnd = end;
  }

  public boolean isLeaf() {
    return isLeaf;
  }
}
