class Todo {
  final String content;
  bool done = false;
  int index;
  Todo(this.content, this.index);

  void markDone() {
    done = !done;
  }
}
