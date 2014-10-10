import "package:unittest/unittest.dart";
import "tictactoe.dart";

/// No duplicate moves allowed
void makeMoveTests() {
  group("makeMove() tests", () {  
    List moves = [[5, true], [5, false], [4, true], [3, true], [4, false]];
    Board board = new Board();
    int moveNum = 1;
    for (List move in moves) {
      test("Move " + moveNum.toString(), () {
        expect(board.makeMove(move[0]), equals(move[1]));
      });
      moveNum++;
    }
  });
}

/// Every time we make 9 random moves, the game should end in a win or draw
void randomMoveTests() {
  group("Random Move Tests", () {
    const int MAX_MOVES = 9;
    for (int j = 0; j < 10; j++) { // play 10 random games
      Board board = new Board();
      test("Random game " + j.toString(), () {
        bool gameWon = false;
        for (int i = 0; i < MAX_MOVES; i++) {
          List legalMoves = board.legalMoves;
          legalMoves.shuffle();
          board.makeMove(legalMoves[0]);
          if (board.winner != null) {
            gameWon = true;
            break;
          }
        }
        expect(gameWon || board.isDraw(), isTrue);
      });
    }
  });
}



void main() {
//  makeMoveTests();
//  randomMoveTests();
}