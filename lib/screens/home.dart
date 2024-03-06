import 'package:flutter/material.dart';
import 'package:mine_sweeper/model/game.dart';
import 'package:mine_sweeper/widgets/block.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // initialize the game manager
  final gameManager = GameManager(8, 8, 10);

  @override
  void initState() {
    // generate mines
    gameManager.generateMines();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mine Sweeper'),
        ),
        body: Column(
          children: [
            Text('Mines: ${gameManager.mines}'),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameManager.generateMines();
                  });
                },
                child: const Text('Restart')),
            board(),
          ],
        ),
      ),
    );
  }

  Widget board() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: [
            // generate 10 rows and 10 columns with a block in each cell
            for (var i = 0; i < gameManager.cols; i++)
              TableRow(
                children: [
                  for (var j = 0; j < gameManager.cols; j++)
                    Block(
                      width: 50,
                      height: 50,
                      text: gameManager.board[i][j].valueToString(),
                      onTap: () => onTap(i, j),
                      onLongPress: () {
                        setState(() {
                          gameManager.board[i][j].isFlagged =
                              !gameManager.board[i][j].isFlagged;
                        });
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void onTap(int i, int j) {
    debugPrint('onTap: $i, $j');
    setState(() {
      gameManager.reveal(i, j);
    });
  }
}
