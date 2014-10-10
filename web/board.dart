part of tictactoe;

class Board {
  List<String> _boxes = new List.filled(9, null);
  String _turn = "X"; // X always starts
  int _move = 0;
  static const int _maxMoves = 9;
  List<List> _nodesInfo = new List(); 
  
  /// Returns the winning letter if there is one, or null if not
  String winner([List<String> boxes]) { // check all 3-in-a-rows
    if (boxes == null) {
      boxes = _boxes;
    }
    if ((boxes[0] != null) && ((boxes[0] == boxes[1]) && (boxes[1] == boxes[2]))) {
      return boxes[0];
    } else if ((boxes[0] != null) && ((boxes[0] == boxes[3]) && (boxes[3] == boxes[6]))) {
      return boxes[0];
    } else if ((boxes[1] != null) && ((boxes[1] == boxes[4]) && (boxes[4] == boxes[7]))) {
      return boxes[1];
    } else if ((boxes[2] != null) && ((boxes[2] == boxes[5]) && (boxes[5] == boxes[8]))) {
      return boxes[2];
    } else if ((boxes[3] != null) && ((boxes[3] == boxes[4]) && (boxes[4] == boxes[5]))) {
      return boxes[3];
    } else if ((boxes[6] != null) && ((boxes[6] == boxes[7]) && (boxes[7] == boxes[8]))) {
      return boxes[6];
    } else if ((boxes[0] != null) && ((boxes[0] == boxes[4]) && (boxes[4] == boxes[8]))) {
      return boxes[0];
    } else if ((boxes[2] != null) && ((boxes[2] == boxes[4]) && (boxes[4] == boxes[6]))) {
      return boxes[2];
    } else {
      return null;
    }
  }
  
  /// Returns true if position is a draw, false otherwise
  bool isDraw([List<String> boxes]) {
    if (boxes == null) {
      boxes = _boxes;
    }
    
    if (!boxes.contains(null) && winner() == null) {
      return true;
    } else {
      return false;
    }
  }
  
  /// Returns a List<int> containing open squares
  List<int> get legalMoves {
    List<int> legalMoves = new List();
    for (int i = 0; i < _boxes.length; i++) {
      if (_boxes[i] == null) {
        legalMoves.add(i);
      }
    }
    return legalMoves;
  }
  
  /// Attempts to make [move], returns if could be made or not as bool
  bool makeMove(int move) {
    if (move < 0 || move > _boxes.length) { // only 0 - 8 are legal
      throw new RangeError.range(move, 0, _boxes.length);
    }
    if (_boxes[move] == null && winner() == null) {
      _boxes[move] = _turn;
      _turn = _turn == "O" ? "X" : "O"; // flip _turn
      return true;
    } else {
      return false;
    }
  }
  
  /// If the move is valid, makes a new move.
  void play(int field) {
    if (makeMove(field) == true) {
      _move++;
      draw(myCanvas);
      if (winner() != null) {
        if (useMinimax) {
          if (winner() == "X") {
            showMessage("You are the winner!", "green");
          } else {
            showMessage("Computer was better :-(", "red");
          }
        } else {
          showMessage(winner() + " wins!", "green");
        }
      } else if (isDraw()) {
        showMessage("Draw", "red");
      } else if (useMinimax == true && _turn == "O") {
        play(bestMove(_turn));
      }
    }
  }
  
  /// Returns +1 if "X" wins, -1 if "O" wins, 0 if it is draw, null if there is now result
  int getNodeValue(List<String> boxes, String player) {
    String opponent = player == "O" ? "X" : "O"; // flip player
    if (winner(boxes) == player) {
      return 1;
    } else if (winner(boxes) == opponent) {
      return -1;
    } else if (isDraw(boxes) == true) {
      return 0;
    } else {
      return null;
    }
  }
  
  /// Calculates the minimax value of the node. The minimax algorithm correspods to the pseudocode at: http://en.wikipedia.org/wiki/Minimax
  int minimax(int node, int depth, bool maximizing, List<String> boxes, String player) {
    String opponent = player == "O" ? "X" : "O"; // flip player
    List<String> newBoxes = new List();
    for (String box in boxes) {
      newBoxes.add(box);
    }
    if (maximizing) {
      newBoxes[node] = opponent;
    } else {
      newBoxes[node] = player;
    }
    
    List<int> nodeValues = new List();
    for (int i = 0; i < newBoxes.length; i++) {
      nodeValues.add(-2);
    }
    
    if (isDraw(newBoxes) || winner(newBoxes) != null) {
      return getNodeValue(newBoxes, player);
      
    } else if (maximizing) {
      int bestValue = -1;
      for (int i = 0; i < boxes.length; i++) {
        if (boxes[i] == null && i != node) {
          int value = minimax(i, depth - 1, false, newBoxes, player);
          if (value > bestValue) {
            bestValue = value;
          }
          nodeValues[i] = value;
        }
      }
      _nodesInfo.add([node, depth, maximizing, nodeValues, bestValue]);
      return bestValue;
      
    } else {
      int bestValue = 1;
      for (int i = 0; i < boxes.length; i++) {
        if (boxes[i] == null && i != node) {
          int value = minimax(i, depth - 1, true, newBoxes, player);
          if (value < bestValue) {
            bestValue = value;
          }
          nodeValues[i] = value;
        }
      }
      _nodesInfo.add([node, depth, maximizing, nodeValues, bestValue]);
      return bestValue;
    }
  }
  
  
  /// Calculates the best move (with use of minimax algorithm)
  int bestMove(String player) {
    _nodesInfo = [];
    int depth = _maxMoves - _move;
    if (depth > minimaxPlies) {
      depth = minimaxPlies;
    }
    List<int> moveValues = new List();
    for (int i = 0; i < _boxes.length; i++) {
      moveValues.add(-2);
    }
    
    for (int i = 0; i < _boxes.length; i++) {
      if (_boxes[i] == null) {
        moveValues[i] = minimax(i, depth, false, _boxes, player);
      }
    }
    
    List<int> bestMoves = new List();
    for (int i = 0; i < moveValues.length; i++) {
      if (moveValues[i] == moveValues.reduce(max)) {
        bestMoves.add(i);
      }
    }
    
    bestMoves.shuffle(); // If there is more possible moves the computer will randomly choose one.
    return bestMoves[0];
  }
  
  /// Draws current position on myCanvas, respecting width/height
  void draw(CanvasElement canvas) {
    CanvasRenderingContext2D ctx = canvas.context2D;
    ImageElement background = new ImageElement()
            ..src = "images/background.png",
            circle = new ImageElement()
            ..src = "images/circle.png",
            cross = new ImageElement()
            ..src = "images/cross.png";
    ctx.setFillColorRgb(255, 255, 255);
    ctx.fillRect(0, 0, 300, 300);
    background.onLoad.listen((value) => ctx.drawImage(background, 0, 0));
    for (int i = 0; i < _boxes.length; i++) {
      if (_boxes[i]  != null) {
        num destX = canvas.width / 6;
        if (i % 3 == 1) {
          destX = canvas.width / 2;
        } else if (i % 3 == 2) {
          destX = canvas.width / 6 * 5;
        }
        num destY = canvas.height / 6;
        if (i > 5) {
          destY = canvas.height / 6 * 5;
        } else if (i > 2) {
          destY = canvas.height / 2;
        }

        int imageRadius = 35;
        destX -= imageRadius;
        destY -= imageRadius;
        if (_boxes[i] == "X") {
          background.onLoad.listen((value) => ctx.drawImage(cross, destX, destY));
        } else {
          background.onLoad.listen((value) => ctx.drawImage(circle, destX, destY));
        }
      }
    }
  }
  
  void showMessage(String message, String color) {
    querySelector("#messages")
      ..text = message
      ..style.color = color;
  }
  
  void errorMessage(String message) {
    DivElement errorMessage = new DivElement()
      ..id = "error";
    errorMessage.text = message;
    document.body.nodes.add(errorMessage);
  }
  
  void showMinimax() {
    for (int i = minimaxPlies; i >= 0; i--) {
      List constantDepthNodeValues = [];
      bool depthMaximization = false;
      bool depthActive = false;
      for (List nodeInfo in _nodesInfo) {
        if (nodeInfo[1] == i) {
          constantDepthNodeValues.add([nodeInfo[0], nodeInfo[3], nodeInfo[4]]);
          depthMaximization = nodeInfo[2];
          depthActive = true;
        }
      }
      if (depthActive) {
        errorMessage("Depth: " + i.toString() + ", Maximization: " + depthMaximization.toString());
        errorMessage(constantDepthNodeValues.toString());
        errorMessage("---------------");
      }
    }
  }
  
  void restart() {
    for (int i = 0; i < _boxes.length; i++) {
      _boxes[i] = null;
    }
    _turn = "X";
    _move = 0;
    showMessage("", "black");
    draw(myCanvas);
    
    ElementList errorMessages = querySelectorAll("#error");
    for (Element errorMessage in errorMessages) {
      errorMessage.remove();
    }
  }
}