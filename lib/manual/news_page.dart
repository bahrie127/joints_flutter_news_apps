import 'package:flutter/material.dart';
import 'package:flutter_joints_news_apps/data/article_model.dart';
import 'package:flutter_joints_news_apps/data/network_manager.dart';

import 'news_detail.dart';


class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> listNews;
  late TextEditingController _searchController;

  @override
  void initState() {
    listNews = NetworkManager().getAllNews();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joints News App')),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        if (value.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Text Search tidak boleh kosng'),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          listNews = NetworkManager()
                              .getSearchNews(_searchController.text);
                          setState(() {});
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Searching berhasil'),
                            backgroundColor: Colors.blue,
                          ));
                        }
                      },
                      controller: _searchController,
                      decoration: const InputDecoration(labelText: 'Search'),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      if (_searchController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Text Search tidak boleh kosng'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        listNews = NetworkManager()
                            .getSearchNews(_searchController.text);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
          ),
          FutureBuilder(
            future: listNews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NewsDetail(news: snapshot.data![index]);
                          }));
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              snapshot.data![index].title!,
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                    child: Text(snapshot.data![index].author!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1)),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Text(
                                  '${snapshot.data![index].publishedAt!}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        thickness: 2,
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
