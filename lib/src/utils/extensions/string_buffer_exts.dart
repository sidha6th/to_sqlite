extension StringBufferExts on StringBuffer {
  void writeIfValid(String char, bool skip) {
    if (skip) {
      return;
    }
    write(char);
  }

  void customWrite(String char, {String preChar = '', String postChar = ''}) {
    write(preChar + char + postChar);
  }
}
