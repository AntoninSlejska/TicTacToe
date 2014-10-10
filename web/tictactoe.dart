library tictactoe;

import 'dart:html';
import 'dart:math';

part 'board.dart';

CanvasElement myCanvas = querySelector("#myCanvas");
Board board = new Board();
int minimaxPlies = 8;
bool useMinimax = true; // The player plays agains the computer (AI with minimax algorithm)

/// When the canvas is clicked, we make a move at the appropriate box, check if the game is over and redraw the canvas.
void clickHappened(MouseEvent me) {
  int clickX = me.offset.x;
  int clickY = me.offset.y;
  num col = clickX ~/ (myCanvas.width / 3);
  num row = clickY ~/ (myCanvas.height / 3);
  
  if (row == 1) { // reuse col as exact box number
    col += 3;
  } else if (row == 2) {
    col += 6;
  }
  
  board.play(col);
}

void userCommands(Event event) {
  Element clickedElement = event.target;
  switch (clickedElement.id){
    case "restart" :
      board.restart();
      break;
    case "one-player" :
      useMinimax = true;
      board.restart();
      break;
    case "two-players" :
      useMinimax = false;
      board.restart();
      break;
    case "minimax" :
      board.showMinimax();
      break;
  }
}

void main() {
  myCanvas.onClick.listen(clickHappened);
  querySelector("#restart").onClick.listen(userCommands);
  querySelector("#one-player").onChange.listen(userCommands);
  querySelector("#two-players").onChange.listen(userCommands);
//  querySelector("#minimax").onClick.listen(userCommands);
  board.draw(myCanvas);
}