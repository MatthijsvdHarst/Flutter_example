import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite List Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const InfiniteListPage(),
    );
  }
}

class InfiniteListPage extends StatefulWidget {
  const InfiniteListPage({super.key});

  @override
  State<InfiniteListPage> createState() => _InfiniteListPageState();
}

class _InfiniteListPageState extends State<InfiniteListPage> {
  final List<int> _items = [];
  final ScrollController _controller = ScrollController();
  bool _loading = false;
  int _nextItem = 0;

  @override
  void initState() {
    super.initState();
    _loadMore();
    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_loading) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadMore() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _items.addAll(List.generate(20, (i) => _nextItem + i));
        _nextItem += 20;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: _items.length + 1,
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return _loading
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          final item = _items[index];
          return ListTile(
            title: Text('Item $item'),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => DetailPage(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.item});

  final int item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail $item')),
      body: Center(
        child: Text('Detail page for item $item'),
      ),
    );
  }
}

