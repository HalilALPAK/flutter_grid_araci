import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Kopyalama işlemi için
import 'dart:math'; // min ve max fonksiyonları için

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // DEBUG yazısını kaldırır
      title: 'Flutter Grid Tasarım Aracı',
      themeMode: ThemeMode.system, // Sistem temasına göre Dark/Light
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey[50], // Açık gri arka plan
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800], // Koyu AppBar
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Düzeltme burada: OutlinedButtonData -> OutlinedButtonThemeData
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontSize: 14),
            side: BorderSide(color: Colors.blueGrey.shade300, width: 1.5),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // TextField teması
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blueGrey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueGrey.shade600, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          isDense: true,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey[900], // Koyu arka plan
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900], // Daha koyu AppBar
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.teal.shade700, // Koyu modda farklı renk
            foregroundColor: Colors.white,
          ),
        ),
        // Düzeltme burada: OutlinedButtonData -> OutlinedButtonThemeData
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontSize: 14),
            side: BorderSide(color: Colors.blueGrey.shade700, width: 1.5),
            foregroundColor: Colors.white70,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: Colors.blueGrey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // TextField teması
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.blueGrey[700],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          isDense: true,
        ),
      ),
      home: const GridSelectionScreen(),
    );
  }
}

class GridSelectionScreen extends StatefulWidget {
  const GridSelectionScreen({super.key});

  @override
  State<GridSelectionScreen> createState() => _GridSelectionScreenState();
}

class _GridSelectionScreenState extends State<GridSelectionScreen> {
  // Grid boyutları
  int gridRows = 5;
  int gridCols = 5;

  // TextEditingController'lar grid boyutu girişleri için
  late TextEditingController _rowsController;
  late TextEditingController _colsController;

  // Hücre verilerini tutacak liste (En üst seviye grid)
  List<List<CellData>> gridData = [];

  // Sürükleme ile seçim durumu
  bool isDragging = false;

  // Seçilen renk ve renk seçenekleri
  Color selectedColor = Colors.deepOrange; // Başlangıç rengi
  final List<Color> colorOptions = [
    Colors.deepOrange,
    Colors.teal,
    Colors.indigo,
    Colors.purple,
    Colors.redAccent,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.cyan,
    Colors.brown,
    Colors.lime,
    Colors.pink,
    Colors.blueGrey,
    Colors.grey.shade700,
    Colors.black,
    Colors.orange, // Ek renk
    Colors.lightBlue, // Ek renk
    Colors.deepPurple, // Ek renk
    Colors.lightGreen, // Ek renk
    Colors.yellow, // Ek renk
    Colors.deepOrangeAccent, // Ek renk
    Colors.tealAccent, // Ek renk
    Colors.indigoAccent, // Ek renk
    Colors.purpleAccent, // Ek renk
    Colors.red, // Ek renk
  ];

  // Bölme Modu Yönetimi
  String selectedSplitMode =
      'none'; // 'none', 'row2', 'row3', 'col2', 'col3', 'row4', 'col4', 'row21', 'col21', 'row12', 'col12'

  // Side bar durumu
  bool isSidebarOpen = false;

  // Varsayılan boş hücre rengi
  late Color _defaultEmptyCellColor;

  // Tema modu kontrolü için
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(
    ThemeMode.system,
  );

  // Birleştirme Modu Yönetimi
  bool isMergeMode = false;
  List<List<int>> selectedMergePaths = []; // Seçilen hücrelerin yollarını tutar

  @override
  void initState() {
    super.initState();
    _rowsController = TextEditingController(text: gridRows.toString());
    _colsController = TextEditingController(text: gridCols.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _defaultEmptyCellColor =
        Theme.of(context).brightness == Brightness.light
            ? Colors.grey[200]!
            : Colors.blueGrey[700]!;

    if (gridData.isEmpty) {
      _initializeGrid();
    } else {
      _updateDefaultEmptyCellColorInGrid(gridData);
    }
  }

  @override
  void dispose() {
    _rowsController.dispose();
    _colsController.dispose();
    _themeModeNotifier.dispose();
    super.dispose();
  }

  // Grid'i başlatma veya yeniden oluşturma
  void _initializeGrid() {
    final List<List<CellData>> newGridData = List.generate(
      gridRows,
      (row) => List.generate(gridCols, (col) {
        if (row < gridData.length &&
            col < gridData[row].length &&
            gridData[row][col].splitChildren.isEmpty &&
            !gridData[row][col].isMerged) {
          // Birleştirilmiş hücreleri de koru
          return gridData[row][col];
        }
        return CellData(
          isFilled: false,
          color: _defaultEmptyCellColor,
          splitChildren: [],
          splitDirection: null,
          splitRatio: null,
          isMerged: false,
          mergedCells: [],
        );
      }),
    );

    setState(() {
      gridData = newGridData;
    });
  }

  // Rekürsif olarak tüm hücrelerin varsayılan boş rengini günceller
  void _updateDefaultEmptyCellColorInGrid(List<List<CellData>> currentGrid) {
    for (var row in currentGrid) {
      for (var cell in row) {
        if (!cell.isFilled &&
            cell.splitChildren.isEmpty &&
            !cell.isMerged &&
            cell.color != Colors.transparent) {
          cell.color = _defaultEmptyCellColor;
        }
        if (cell.splitChildren.isNotEmpty) {
          _updateDefaultEmptyCellColorInCellChildren(cell.splitChildren);
        }
      }
    }
    setState(() {}); // UI'ı güncelle
  }

  void _updateDefaultEmptyCellColorInCellChildren(List<CellData> children) {
    for (var childCell in children) {
      if (!childCell.isFilled &&
          childCell.splitChildren.isEmpty &&
          !childCell.isMerged &&
          childCell.color != Colors.transparent) {
        childCell.color = _defaultEmptyCellColor;
      }
      if (childCell.splitChildren.isNotEmpty) {
        _updateDefaultEmptyCellColorInCellChildren(childCell.splitChildren);
      }
    }
  }

  // Tüm seçimleri ve bölmeleri temizler
  void _clearAllSelectionsAndSplits() {
    setState(() {
      _initializeGrid();
      selectedSplitMode = 'none';
      isDragging = false;
      isMergeMode = false;
      selectedMergePaths = [];
    });
  }

  // Hücreye tek tıklandığında durumu güncelleyecek metot (rekürsif)
  void _onCellTap(List<int> path, BuildContext scaffoldContext) {
    CellData? targetCell = _findCellByPath(path, gridData);

    if (targetCell == null) return;

    setState(() {
      if (isMergeMode) {
        // Birleştirme modunda hücre seçimi
        if (targetCell.splitChildren.isNotEmpty) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Bölünmüş parçalar birleştirilemez.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }
        if (targetCell.isMerged) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Bu alan zaten birleştirilmiş.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        if (selectedMergePaths.contains(path)) {
          selectedMergePaths.remove(path);
        } else {
          // Yeni seçilen hücrenin geçerli birleştirme adayı olup olmadığını kontrol et
          // Sadece ana grid hücreleri için geçerli
          if (path.length != 2) {
            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
              const SnackBar(
                content: Text(
                  'Sadece en üst seviye hücreleri birleştirebilirsiniz.',
                ),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          if (selectedMergePaths.isNotEmpty) {
            // Check if the new path is adjacent to any already selected path
            bool isAdjacent = false;
            for (var existingPath in selectedMergePaths) {
              if (_areAdjacent(existingPath, path)) {
                isAdjacent = true;
                break;
              }
            }
            if (!isAdjacent) {
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                const SnackBar(
                  content: Text('Sadece bitişik alanları seçebilirsiniz.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
          }
          selectedMergePaths.add(path);
        }
        return;
      }

      if (selectedSplitMode != 'none') {
        if (targetCell.splitChildren.isEmpty && !targetCell.isMerged) {
          _performSplit(targetCell, selectedSplitMode);
        } else {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text(
                'Bu parça zaten bölünmüş veya birleştirilmiş. Önce rengini değiştirerek temizlemelisiniz.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
        selectedSplitMode = 'none';
        return;
      }

      // Normal tıklama veya sürükleme sonrası renk değişimi
      if (targetCell.isMerged) {
        // Birleştirilmiş bir alana tıklanırsa, tüm birleştirilmiş parçaların rengini değiştir
        for (var p in targetCell.mergedCells) {
          CellData? cellToUpdate = _findCellByPath(p, gridData);
          if (cellToUpdate != null) {
            cellToUpdate.color = selectedColor;
            cellToUpdate.isFilled = true;
          }
        }
      } else if (targetCell.splitChildren.isNotEmpty) {
        // Bölünmüş bir hücreye tıklanırsa, bölmeyi sıfırla ve rengi ayarla
        targetCell.splitChildren = [];
        targetCell.splitDirection = null;
        targetCell.splitRatio = null;
        targetCell.isFilled = true;
        targetCell.color = selectedColor;
      } else {
        // Normal hücreye tıklanırsa
        if (targetCell.isFilled && targetCell.color != selectedColor) {
          targetCell.color = selectedColor;
        } else if (!targetCell.isFilled) {
          targetCell.isFilled = true;
          targetCell.color = selectedColor;
        } else {
          targetCell.isFilled = false;
          targetCell.color = _defaultEmptyCellColor;
        }
      }
    });
  }

  // İki path'in bitişik olup olmadığını kontrol eder (sadece ana grid seviyesi için)
  bool _areAdjacent(List<int> path1, List<int> path2) {
    if (path1.length != 2 || path2.length != 2)
      return false; // Sadece ana grid hücreleri
    int r1 = path1[0], c1 = path1[1];
    int r2 = path2[0], c2 = path2[1];

    // Aynı hücre olamazlar
    if (r1 == r2 && c1 == c2) return false;

    // Yatayda veya dikeyde bitişik mi
    return (r1 == r2 && (c1 - c2).abs() == 1) ||
        (c1 == c2 && (r1 - r2).abs() == 1);
  }

  // Bir hücre yolu (path) ile CellData nesnesini bulan yardımcı metot (rekürsif)
  CellData? _findCellByPath(List<int> path, List<List<CellData>> currentGrid) {
    if (path.isEmpty) return null;

    CellData? foundCell;
    if (path.length >= 2) {
      if (path[0] < currentGrid.length &&
          path[1] < currentGrid[path[0]].length) {
        foundCell = currentGrid[path[0]][path[1]];
      } else {
        return null;
      }
    } else {
      return null;
    }

    for (int i = 2; i < path.length; i++) {
      if (foundCell!.splitChildren.isNotEmpty &&
          path[i] < foundCell.splitChildren.length) {
        foundCell = foundCell.splitChildren[path[i]];
      } else {
        return null;
      }
    }
    return foundCell;
  }

  // Sürükleme başladığında (şimdilik sadece en üst seviye hücreler için)
  void _onPanStart(
    DragStartDetails details,
    int row,
    int col,
    BuildContext scaffoldContext,
  ) {
    if (selectedSplitMode != 'none' || isMergeMode) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Bölme veya birleştirme modunda sürükleme yapılamaz.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final cell = gridData[row][col];
    if (cell.splitChildren.isNotEmpty || cell.isMerged) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Bölünmüş veya birleştirilmiş parçalar sürüklenemez.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isDragging = true;
      cell.isFilled = true;
      cell.color = selectedColor;
      cell.splitChildren = [];
      cell.splitDirection = null;
      cell.splitRatio = null;
    });
  }

  // Sürükleme güncellendiğinde (şimdilik sadece en üst seviye hücreler için)
  void _onPanUpdate(
    DragUpdateDetails details,
    int currentRow,
    int currentCol,
    BuildContext scaffoldContext,
  ) {
    if (isDragging && selectedSplitMode == 'none' && !isMergeMode) {
      final cell = gridData[currentRow][currentCol];
      if (cell.splitChildren.isNotEmpty || cell.isMerged) return;

      setState(() {
        if (!cell.isFilled || cell.color != selectedColor) {
          cell.isFilled = true;
          cell.color = selectedColor;
        }
        cell.splitChildren = [];
        cell.splitDirection = null;
        cell.splitRatio = null;
      });
    }
  }

  // Sürükleme bittiğinde
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });
  }

  // Hücre bölme mantığı
  void _performSplit(CellData cell, String mode) {
    if (cell.splitChildren.isNotEmpty || cell.isMerged) return;

    List<CellData> children = [];
    String direction;
    List<int> ratio = [];

    if (mode.startsWith('row')) {
      direction = 'row';
      if (mode == 'row2') {
        ratio = [1, 1];
      } else if (mode == 'row3') {
        ratio = [1, 1, 1];
      } else if (mode == 'row4') {
        ratio = [1, 1, 1, 1];
      } else if (mode == 'row21') {
        ratio = [2, 1];
      } else if (mode == 'row12') {
        ratio = [1, 2];
      }
    } else {
      // startsWith('col')
      direction = 'column';
      if (mode == 'col2') {
        ratio = [1, 1];
      } else if (mode == 'col3') {
        ratio = [1, 1, 1];
      } else if (mode == 'col4') {
        ratio = [1, 1, 1, 1];
      } else if (mode == 'col21') {
        ratio = [2, 1];
      } else if (mode == 'col12') {
        ratio = [1, 2];
      }
    }

    for (int i = 0; i < ratio.length; i++) {
      children.add(
        CellData(
          isFilled: false,
          color: cell.color,
          splitChildren: [],
          splitDirection: null,
          splitRatio: null,
        ),
      );
    }

    cell.splitChildren = children;
    cell.splitDirection = direction;
    cell.splitRatio = ratio;
    cell.isFilled = false;
    cell.color = Colors.transparent;
  }

  // Hücre birleştirme mantığı
  void _performMerge(BuildContext scaffoldContext) {
    if (selectedMergePaths.isEmpty) {
      // Birleştirme modundan çıkarken birleştirme yapılmadıysa uyarı verme
      if (isMergeMode) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text('Birleştirmek için hücre seçmelisiniz.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (selectedMergePaths.length == 1) {
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Birleştirmek için birden fazla hücre seçmelisiniz.'),
          duration: Duration(seconds: 2),
        ),
      );
      selectedMergePaths = [];
      setState(() {
        isMergeMode = false;
      });
      return;
    }

    // Seçilen hücrelerin bir dikdörtgen oluşturup oluşturmadığını kontrol et
    int minRow = gridRows, maxRow = -1, minCol = gridCols, maxCol = -1;
    for (var path in selectedMergePaths) {
      if (path.length != 2) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Sadece en üst seviye hücreleri birleştirebilirsiniz.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
        selectedMergePaths = [];
        setState(() {
          isMergeMode = false;
        });
        return;
      }
      minRow = min(minRow, path[0]);
      maxRow = max(maxRow, path[0]);
      minCol = min(minCol, path[1]);
      maxCol = max(maxCol, path[1]);
    }

    // Seçilen tüm hücrelerin dikdörtgen alanı doldurduğundan emin olun
    // Bu, aradaki boşlukları veya bitişik olmayan hücreleri içeren seçimleri engeller.
    for (int r = minRow; r <= maxRow; r++) {
      for (int c = minCol; c <= maxCol; c++) {
        if (!selectedMergePaths.contains([r, c])) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Seçili alan bitişik bir dikdörtgen oluşturmuyor.'),
              duration: Duration(seconds: 2),
            ),
          );
          selectedMergePaths = [];
          setState(() {
            isMergeMode = false;
          });
          return;
        }
      }
    }

    // Seçilen hücrelerden herhangi birinin bölünmüş olup olmadığını kontrol et
    for (var path in selectedMergePaths) {
      CellData? cell = _findCellByPath(path, gridData);
      if (cell != null && cell.splitChildren.isNotEmpty) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Seçilen alanlar bölünmüş hücreler içeriyor. Birleştirme yapılamaz.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
        selectedMergePaths = [];
        setState(() {
          isMergeMode = false;
        });
        return;
      }
    }

    setState(() {
      Color mergedColor =
          Colors.transparent; // Birleştirilen hücrelerin rengini alacak
      if (selectedMergePaths.isNotEmpty) {
        mergedColor =
            _findCellByPath(selectedMergePaths.first, gridData)?.color ??
            _defaultEmptyCellColor;
      }

      // Ana grid üzerinde birleştirme işlemini uygula
      // Sadece dikdörtgenin sol üst köşesindeki hücre gerçek görseli tutacak.
      for (int r = minRow; r <= maxRow; r++) {
        for (int c = minCol; c <= maxCol; c++) {
          CellData cell = gridData[r][c];

          // Bu hücreyi birleştirilmiş olarak işaretle
          cell.isMerged = true;
          cell.splitChildren = []; // Bölünmüş durumunu sıfırla
          cell.splitDirection = null;
          cell.splitRatio = null;

          if (r == minRow && c == minCol) {
            // Birleştirilen ana hücre (sol üst köşe)
            cell.color = mergedColor;
            cell.isFilled = true;
            cell.mergedCells =
                selectedMergePaths; // Hangi hücreleri birleştirdiğini sakla
          } else {
            // Diğer birleştirilen hücreleri gizle (Container boş olacak)
            cell.isFilled = false;
            cell.color = Colors.transparent; // Görsel olarak gizle
            cell.mergedCells = []; // Bunlar birleştirilmiş parçalar
          }
        }
      }

      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        const SnackBar(
          content: Text('Seçilen alanlar başarıyla birleştirildi!'),
          duration: Duration(seconds: 2),
        ),
      );

      selectedMergePaths = [];
      isMergeMode = false;
    });
  }

  // Flutter kodunu oluşturacak metot
  String _generateFlutterCode() {
    String colorToCode(Color color) {
      if (color == Colors.red) return 'Colors.red';
      if (color == Colors.green) return 'Colors.green';
      if (color == Colors.blue) return 'Colors.blue';
      if (color == Colors.orange) return 'Colors.orange';
      if (color == Colors.purple) return 'Colors.purple';
      if (color == Colors.yellow) return 'Colors.yellow';
      if (color == Colors.teal) return 'Colors.teal';
      if (color == Colors.brown) return 'Colors.brown';
      if (color == Colors.deepOrange) return 'Colors.deepOrange';
      if (color == Colors.indigo) return 'Colors.indigo';
      if (color == Colors.redAccent) return 'Colors.redAccent';
      if (color == Colors.amber) return 'Colors.amber';
      if (color == Colors.cyan) return 'Colors.cyan';
      if (color == Colors.lime) return 'Colors.lime';
      if (color == Colors.pink) return 'Colors.pink';
      if (color == Colors.blueGrey) return 'Colors.blueGrey';
      if (color == Colors.grey[200]) return 'Colors.grey[200]!';
      if (color == Colors.grey[700]) return 'Colors.grey[700]!';
      if (color == Colors.black) return 'Colors.black';
      if (color == Colors.transparent) return 'Colors.transparent';
      if (color == Colors.lightBlue) return 'Colors.lightBlue';
      if (color == Colors.deepPurple) return 'Colors.deepPurple';
      if (color == Colors.lightGreen) return 'Colors.lightGreen';
      if (color == Colors.deepOrangeAccent) return 'Colors.deepOrangeAccent';
      if (color == Colors.tealAccent) return 'Colors.tealAccent';
      if (color == Colors.indigoAccent) return 'Colors.indigoAccent';
      if (color == Colors.purpleAccent) return 'Colors.purpleAccent';

      return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
    }

    // Rekürsif olarak hücrelerin kodunu oluşturan yardımcı fonksiyon
    String _generateCellCode(CellData cell) {
      if (cell.splitChildren.isEmpty) {
        // Birleştirilmiş ana hücreler için veya normal hücreler için
        return '''
          Container(
            color: ${colorToCode(cell.color)},
            margin: const EdgeInsets.all(2.0),
            ${!cell.isFilled && (cell.color == _defaultEmptyCellColor) ? '// Bu alan boş, varsayılan renk.' : ''}
          )
        ''';
      } else {
        String childrenCode = '';
        if (cell.splitRatio != null &&
            cell.splitChildren.length == cell.splitRatio!.length) {
          for (int i = 0; i < cell.splitChildren.length; i++) {
            childrenCode += '''
            Expanded(
              flex: ${cell.splitRatio![i]},
              child: Padding(
                padding: const EdgeInsets.all(2.0), // İç bölmeler arasına boşluk
                child: ${_generateCellCode(cell.splitChildren[i])}
              )
            ),
          ''';
          }
        } else {
          childrenCode = cell.splitChildren
              .map((childCell) {
                return '''
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0), // İç bölmeler arasına boşluk
                child: ${_generateCellCode(childCell)}
              )
            ),
          ''';
              })
              .join('\n');
        }

        if (cell.splitDirection == 'row') {
          return '''
            Row(
              children: <Widget>[
                $childrenCode
              ],
            )
          ''';
        } else {
          return '''
            Column(
              children: <Widget>[
                $childrenCode
              ],
            )
          ''';
        }
      }
    }

    StringBuffer code = StringBuffer();
    code.writeln('Column(');
    code.writeln('  children: <Widget>[');

    List<List<bool>> visited = List.generate(
      gridRows,
      (r) => List.generate(gridCols, (c) => false),
    );

    for (int r = 0; r < gridRows; r++) {
      code.writeln('    Expanded(');
      code.writeln('      child: Row(');
      code.writeln('        children: <Widget>[');

      for (int col = 0; col < gridCols; col++) {
        if (visited[r][col]) {
          continue;
        }

        final cell = gridData[r][col];

        if (cell.isMerged && cell.mergedCells.isNotEmpty) {
          // Bu birleştirilmiş alanın ana hücresi
          int minRow = gridRows, maxRow = -1, minCol = gridCols, maxCol = -1;
          for (var path in cell.mergedCells) {
            minRow = min(minRow, path[0]);
            maxRow = max(maxRow, path[0]);
            minCol = min(minCol, path[1]);
            maxCol = max(maxCol, path[1]);
          }

          int rowSpan = maxRow - minRow + 1;
          int colSpan = maxCol - minCol + 1;

          code.writeln('          Expanded(');
          code.writeln(
            '            flex: $colSpan, // ${colSpan} sütun birleştirildi',
          );
          code.writeln('            child: Column(');
          code.writeln('              children: <Widget>[');
          code.writeln('                Expanded(');
          code.writeln(
            '                  flex: $rowSpan, // ${rowSpan} satır birleştirildi',
          );
          code.writeln('                  child: ${_generateCellCode(cell)}');
          code.writeln('                ),');
          code.writeln('              ],');
          code.writeln('            ),');
          code.writeln('          ),');

          // Birleştirilen hücreleri ziyaret edildi olarak işaretle
          for (int i = minRow; i <= maxRow; i++) {
            for (int j = minCol; j <= maxCol; j++) {
              visited[i][j] = true;
            }
          }
        } else {
          // Normal veya bölünmüş hücre
          code.writeln('          Expanded(');
          code.writeln('            child: ${_generateCellCode(cell)}');
          code.writeln('          ),');
          visited[r][col] = true;
        }
      }
      code.writeln('        ],');
      code.writeln('      ),');
      code.writeln('    ),');
    }
    code.writeln('  ],');
    code.writeln(');');
    return code.toString();
  }

  @override
  Widget build(BuildContext context) {
    void _toggleTheme() {
      if (_themeModeNotifier.value == ThemeMode.light) {
        _themeModeNotifier.value = ThemeMode.dark;
      } else {
        _themeModeNotifier.value = ThemeMode.light;
      }
    }

    final colorPickerWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            'Renk Seç:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color:
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.blueGrey[700]
                      : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 96, // Yüksekliği artırıldı (2 satır 40px + marjinler)
          child: GridView.builder(
            shrinkWrap: true, // İçeriğe göre boyutlanmasını sağlar
            physics:
                const NeverScrollableScrollPhysics(), // Kaydırmayı devre dışı bırak
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Her satırda 5 renk
              crossAxisSpacing: 8, // Yatay boşluk
              mainAxisSpacing: 8, // Dikey boşluk
              childAspectRatio: 1, // Kare hücreler
            ),
            itemCount: colorOptions.length,
            itemBuilder: (context, index) {
              final color = colorOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                    selectedSplitMode = 'none';
                    isMergeMode =
                        false; // Renk seçince birleştirme modunu kapat
                    selectedMergePaths = [];
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color:
                          selectedColor == color
                              ? Theme.of(context).primaryColorDark
                              : Colors.transparent,
                      width: selectedColor == color ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      selectedColor == color
                          ? Icon(
                            Icons.check,
                            color:
                                (color.computeLuminance() > 0.5)
                                    ? Colors.black
                                    : Colors.white,
                            size: 20,
                          )
                          : null,
                ),
              );
            },
          ),
        ),
      ],
    );

    final splitButtonsWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            child: Text(
              'Bölme Seçenekleri:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.blueGrey[700]
                        : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _buildSplitButton(
                context,
                'Dikey 2 (1:1)',
                'col2',
                Icons.vertical_split,
              ),
              _buildSplitButton(
                context,
                'Dikey 3 (1:1:1)',
                'col3',
                Icons.vertical_split,
              ),
              _buildSplitButton(
                context,
                'Dikey 4 (1:1:1:1)',
                'col4',
                Icons.vertical_split,
              ),
              _buildSplitButton(
                context,
                'Dikey 2:1',
                'col21',
                Icons.vertical_split,
              ),
              _buildSplitButton(
                context,
                'Dikey 1:2',
                'col12',
                Icons.vertical_split,
              ),
              _buildSplitButton(
                context,
                'Yatay 2 (1:1)',
                'row2',
                Icons.horizontal_split,
              ),
              _buildSplitButton(
                context,
                'Yatay 3 (1:1:1)',
                'row3',
                Icons.horizontal_split,
              ),
              _buildSplitButton(
                context,
                'Yatay 4 (1:1:1:1)',
                'row4',
                Icons.horizontal_split,
              ),
              _buildSplitButton(
                context,
                'Yatay 2:1',
                'row21',
                Icons.horizontal_split,
              ),
              _buildSplitButton(
                context,
                'Yatay 1:2',
                'row12',
                Icons.horizontal_split,
              ),
            ],
          ),
          if (selectedSplitMode != 'none')
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                'Bölme Modu Aktif: ${_getSplitModeDisplayName(selectedSplitMode)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Grid Tasarım Aracı',
          themeMode: currentThemeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.blueGrey[50],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey[800],
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 4,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Düzeltme burada: OutlinedButtonData -> OutlinedButtonThemeData
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 14),
                side: BorderSide(color: Colors.blueGrey.shade300, width: 1.5),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.blueGrey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.blueGrey.shade600,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              isDense: true,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blueGrey,
            scaffoldBackgroundColor: Colors.blueGrey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey[900],
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 4,
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            // Düzeltme burada: OutlinedButtonData -> OutlinedButtonThemeData
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontSize: 14),
                side: BorderSide(color: Colors.blueGrey.shade700, width: 1.5),
                foregroundColor: Colors.white70,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              color: Colors.blueGrey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.blueGrey[700],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              isDense: true,
            ),
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Grid Tasarım Aracı'),
              leading: IconButton(
                icon: Icon(isSidebarOpen ? Icons.close : Icons.menu),
                onPressed: () {
                  setState(() {
                    isSidebarOpen = !isSidebarOpen;
                  });
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    currentThemeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: _toggleTheme,
                  tooltip: 'Temayı Değiştir',
                ),
              ],
            ),
            // Hata düzeltmesi burada başlıyor: Builder ekleniyor
            body: Builder(
              builder: (BuildContext scaffoldContext) {
                return Row(
                  children: [
                    // Yan Bar (Sadece isSidebarOpen true ise görünür)
                    if (isSidebarOpen)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 300, // Side bar genişliği
                        decoration: BoxDecoration(
                          color: Theme.of(scaffoldContext).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(4, 0),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Grid Boyutu Ayarlama Seçenekleri
                              Text(
                                'Grid Boyutları',
                                style: Theme.of(
                                  scaffoldContext,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(scaffoldContext).brightness ==
                                              Brightness.light
                                          ? Colors.blueGrey[800]
                                          : Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Satır:',
                                          style:
                                              Theme.of(
                                                scaffoldContext,
                                              ).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            int? newRows = int.tryParse(value);
                                            if (newRows != null &&
                                                newRows > 0 &&
                                                newRows <= 10) {
                                              // Max 10 satır
                                              setState(() {
                                                gridRows = newRows;
                                                _initializeGrid();
                                              });
                                            } else if (newRows != null &&
                                                newRows > 10) {
                                              ScaffoldMessenger.of(
                                                scaffoldContext,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Maksimum 10 satır girebilirsiniz.',
                                                  ),
                                                  duration: Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                              _rowsController.text = '10';
                                              setState(() {
                                                gridRows = 10;
                                                _initializeGrid();
                                              });
                                            }
                                          },
                                          controller: _rowsController,
                                          decoration: const InputDecoration(
                                            hintText: 'örn: 5',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sütun:',
                                          style:
                                              Theme.of(
                                                scaffoldContext,
                                              ).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            int? newCols = int.tryParse(value);
                                            if (newCols != null &&
                                                newCols > 0 &&
                                                newCols <= 10) {
                                              // Max 10 sütun
                                              setState(() {
                                                gridCols = newCols;
                                                _initializeGrid();
                                              });
                                            } else if (newCols != null &&
                                                newCols > 10) {
                                              ScaffoldMessenger.of(
                                                scaffoldContext,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Maksimum 10 sütun girebilirsiniz.',
                                                  ),
                                                  duration: Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                              _colsController.text = '10';
                                              setState(() {
                                                gridCols = 10;
                                                _initializeGrid();
                                              });
                                            }
                                          },
                                          controller: _colsController,
                                          decoration: const InputDecoration(
                                            hintText: 'örn: 5',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 32, thickness: 1),
                              colorPickerWidget,
                              const Divider(height: 32, thickness: 1),
                              splitButtonsWidget,
                              const Divider(height: 32, thickness: 1),
                              // Birleştirme Butonu
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    if (isMergeMode) {
                                      _performMerge(
                                        scaffoldContext,
                                      ); // Birleştirme modundan çıkarken işlemi yap
                                    }
                                    isMergeMode = !isMergeMode;
                                    selectedSplitMode =
                                        'none'; // Birleştirme moduna geçince bölme modunu kapat
                                    isDragging = false; // Sürüklemeyi kapat
                                    if (isMergeMode) {
                                      selectedMergePaths =
                                          []; // Yeni birleştirme seçimi için sıfırla
                                      ScaffoldMessenger.of(
                                        scaffoldContext,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Birleşecek bölümleri seçin.',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  });
                                },
                                icon: Icon(
                                  isMergeMode
                                      ? Icons.done_all
                                      : Icons.merge_type,
                                ),
                                label: Text(
                                  isMergeMode
                                      ? 'Seçimi Bitir ve Birleştir'
                                      : 'Alanları Birleştir',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isMergeMode
                                          ? Colors.green.shade700
                                          : Colors.blueGrey[600],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _clearAllSelectionsAndSplits,
                                icon: const Icon(Icons.clear_all),
                                label: const Text(
                                  'Tüm Seçim ve Bölmeleri Temizle',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey[600],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  final code = _generateFlutterCode();
                                  showDialog(
                                    context:
                                        scaffoldContext, // Burada scaffoldContext kullanılıyor
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Oluşturulan Flutter Kodu',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: SelectableText(
                                            code,
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Kopyala',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      dialogContext,
                                                    ).primaryColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(text: code),
                                              );
                                              Navigator.of(dialogContext).pop();
                                              ScaffoldMessenger.of(
                                                scaffoldContext,
                                              ).showSnackBar(
                                                // Burada da scaffoldContext
                                                const SnackBar(
                                                  content: Text(
                                                    'Kod panoya kopyalandı!',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Kapat',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      dialogContext,
                                                    ).primaryColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Flutter Kodu Oluştur'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Ana Grid Alanı
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                Theme.of(scaffoldContext).brightness ==
                                        Brightness.light
                                    ? Colors.blueGrey.shade300
                                    : Colors.blueGrey.shade700,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          color:
                              Theme.of(scaffoldContext).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors
                                      .blueGrey[800], // Grid'in arka plan rengi
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: List.generate(gridRows, (row) {
                              return Expanded(
                                child: Row(
                                  children: List.generate(gridCols, (col) {
                                    final cellData = gridData[row][col];
                                    // Eğer bu hücre bir birleştirilmiş alanın parçası ise ve ana hücre değilse, gizle.
                                    // Ana hücre, mergedCells listesinin ilk elemanı tarafından temsil edilir.
                                    if (cellData.isMerged &&
                                        (cellData.mergedCells.isEmpty ||
                                            cellData.mergedCells.first[0] !=
                                                row ||
                                            cellData.mergedCells.first[1] !=
                                                col)) {
                                      return const SizedBox.shrink();
                                    }
                                    return Expanded(
                                      child: _buildCellWidget(cellData, [
                                        row,
                                        col,
                                      ], scaffoldContext),
                                    );
                                  }),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Bölme butonu için yardımcı widget
  Widget _buildSplitButton(
    BuildContext context,
    String text,
    String mode,
    IconData icon,
  ) {
    bool isSelected = selectedSplitMode == mode;
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          selectedSplitMode = isSelected ? 'none' : mode;
          isDragging = false;
          isMergeMode = false; // Bölme moduna geçince birleştirme modunu kapat
          selectedMergePaths = [];
        });
      },
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isSelected
                ? Colors.white
                : Theme.of(context).textTheme.labelLarge?.color,
        backgroundColor:
            isSelected
                ? Colors.deepOrange.shade600
                : Theme.of(context).cardColor,
        side: BorderSide(
          color:
              isSelected
                  ? Colors.deepOrange
                  : Theme.of(
                        context,
                      ).outlinedButtonTheme.style?.side?.resolve({})?.color ??
                      Colors.blueGrey.shade300,
          width: 1.5,
        ),
      ),
      icon: Icon(icon, size: 18),
      label: Text(text),
    );
  }

  // Bölme modu adlarını kullanıcı dostu göstermek için
  String _getSplitModeDisplayName(String mode) {
    switch (mode) {
      case 'col2':
        return 'Dikey 2 (1:1)';
      case 'col3':
        return 'Dikey 3 (1:1:1)';
      case 'col4':
        return 'Dikey 4 (1:1:1:1)';
      case 'col21':
        return 'Dikey 2:1';
      case 'col12':
        return 'Dikey 1:2';
      case 'row2':
        return 'Yatay 2 (1:1)';
      case 'row3':
        return 'Yatay 3 (1:1:1)';
      case 'row4':
        return 'Yatay 4 (1:1:1:1)';
      case 'row21':
        return 'Yatay 2:1';
      case 'row12':
        return 'Yatay 1:2';
      default:
        return 'Yok';
    }
  }

  // Hücreleri rekürsif olarak inşa eden yardımcı metod
  Widget _buildCellWidget(
    CellData cellData,
    List<int> path,
    BuildContext scaffoldContext,
  ) {
    bool isSelectedForMerge = isMergeMode && selectedMergePaths.contains(path);

    // Eğer hücre birleştirilmiş bir alanın parçası ise ve ana hücre değilse, boş bir widget döndür.
    // Ana hücre, mergedCells listesinin ilk elemanı tarafından temsil edilir.
    if (cellData.isMerged &&
        (cellData
                .mergedCells
                .isEmpty || // Bu hücre birleştirilmiş ama mergedCells boşsa (alt parça)
            cellData.mergedCells.first[0] !=
                path[0] || // Ana hücrenin satırı değilse
            cellData.mergedCells.first[1] != path[1])) {
      // Ana hücrenin sütunu değilse
      return const SizedBox.shrink(); // Bu birleştirilmiş alanın alt parçasıdır, gösterilmez.
    }

    return GestureDetector(
      onTap:
          () => _onCellTap(
            path,
            scaffoldContext,
          ), // scaffoldContext buraya iletiliyor
      onPanStart:
          selectedSplitMode != 'none' ||
                  isMergeMode ||
                  cellData.splitChildren.isNotEmpty ||
                  cellData.isMerged
              ? null
              : (details) => _onPanStart(
                details,
                path[0],
                path[1],
                scaffoldContext,
              ), // scaffoldContext buraya iletiliyor
      onPanUpdate:
          selectedSplitMode != 'none' ||
                  isMergeMode ||
                  cellData.splitChildren.isNotEmpty ||
                  cellData.isMerged
              ? null
              : (details) => _onPanUpdate(
                details,
                path[0],
                path[1],
                scaffoldContext,
              ), // scaffoldContext buraya iletiliyor
      onPanEnd:
          selectedSplitMode != 'none' ||
                  isMergeMode ||
                  cellData.splitChildren.isNotEmpty ||
                  cellData.isMerged
              ? null
              : (details) => _onPanEnd(details),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color:
              cellData.isFilled
                  ? cellData.color
                  : (cellData.color == Colors.transparent
                      ? Colors.transparent
                      : _defaultEmptyCellColor),
          border: Border.all(
            color:
                isSelectedForMerge
                    ? Colors
                        .redAccent // Birleştirme modunda seçiliyse kırmızı çerçeve
                    : (selectedSplitMode != 'none'
                        ? Colors
                            .deepOrange // Bölme modunda vurgu
                        : (cellData.isFilled
                            ? Colors.blueAccent
                            : (Theme.of(scaffoldContext).brightness ==
                                    Brightness
                                        .light // scaffoldContext kullanılıyor
                                ? Colors.blueGrey.shade200
                                : Colors.blueGrey.shade600))),
            width:
                isSelectedForMerge
                    ? 3.0
                    : (selectedSplitMode != 'none'
                        ? 3.0
                        : (cellData.isFilled ? 2.0 : 1.0)),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child:
            cellData.splitChildren.isEmpty &&
                    !cellData
                        .isMerged // Ne bölünmüş ne de birleştirilmişse
                ? Center(
                  child: Text(
                    path.map((e) => e.toString()).join(','),
                    style: TextStyle(
                      color:
                          (cellData.isFilled
                                          ? cellData.color
                                          : _defaultEmptyCellColor)
                                      .computeLuminance() >
                                  0.5
                              ? Colors.black87
                              : Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                : cellData.isMerged &&
                    cellData
                        .mergedCells
                        .isNotEmpty // Eğer birleştirilmiş ve ana hücre ise
                ? Center(
                  child: Text(
                    'MERGED\n${path.map((e) => e.toString()).join(',')}', // Birleştirilmiş olduğunu belirt
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          cellData.color.computeLuminance() > 0.5
                              ? Colors.black87
                              : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : (cellData.splitDirection == 'row'
                    ? Row(
                      children:
                          cellData.splitChildren.asMap().entries.map((entry) {
                            int childIndex = entry.key;
                            CellData childCell = entry.value;
                            return Expanded(
                              flex:
                                  cellData.splitRatio != null &&
                                          childIndex <
                                              cellData.splitRatio!.length
                                      ? cellData.splitRatio![childIndex]
                                      : 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _buildCellWidget(
                                  childCell,
                                  [...path, childIndex],
                                  scaffoldContext,
                                ), // scaffoldContext alt hücrelere de iletiliyor
                              ),
                            );
                          }).toList(),
                    )
                    : Column(
                      children:
                          cellData.splitChildren.asMap().entries.map((entry) {
                            int childIndex = entry.key;
                            CellData childCell = entry.value;
                            return Expanded(
                              flex:
                                  cellData.splitRatio != null &&
                                          childIndex <
                                              cellData.splitRatio!.length
                                      ? cellData.splitRatio![childIndex]
                                      : 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _buildCellWidget(
                                  childCell,
                                  [...path, childIndex],
                                  scaffoldContext,
                                ), // scaffoldContext alt hücrelere de iletiliyor
                              ),
                            );
                          }).toList(),
                    )),
      ),
    );
  }
}

// Hücre verilerini tutacak sınıf
class CellData {
  bool isFilled;
  Color color;
  List<CellData> splitChildren;
  String? splitDirection;
  List<int>? splitRatio;
  bool
  isMerged; // Bu hücrenin birleştirilmiş bir alanın parçası olup olmadığını gösterir
  List<List<int>>
  mergedCells; // Eğer ana birleştirilmiş hücre ise, hangi hücreleri kapsadığını tutar

  CellData({
    required this.isFilled,
    required this.color,
    this.splitChildren = const [],
    this.splitDirection,
    this.splitRatio,
    this.isMerged = false,
    this.mergedCells = const [],
  });
}
