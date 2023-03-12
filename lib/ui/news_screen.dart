import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joints_news_apps/bloc/news_bloc.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News App - Bloc')),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        context
                            .read<NewsBloc>()
                            .add(NewsSearchEvent(search: value));
                      },
                      controller: _controller,
                      decoration:
                          const InputDecoration(labelText: 'Search Bro'),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                        onPressed: () {
                          context
                              .read<NewsBloc>()
                              .add(NewsSearchEvent(search: _controller.text));
                        },
                        icon: const Icon(Icons.search_sharp)))
              ],
            ),
          ),
          BlocConsumer<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is NewsLoadedState) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(state.listNews[index].title!),
                          subtitle:
                              Text('${state.listNews[index].publishedAt}'),
                        ),
                      );
                    },
                    itemCount: state.listNews.length,
                  ),
                );
              }
              if (state is NewsInitial) {
                return const Center(
                  child: Text('No data'),
                );
              }
              return const Center(
                child: Text('No data'),
              );
            },
            listener: (context, state) {
              if (state is NewsLoadingState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'Pencarian Sedang Berlangsung',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.amber.shade200,
                ));
              }
              if (state is NewsLoadedState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Pencarian Berhasil'),
                  backgroundColor: Colors.blue,
                ));
              }
            },
          ),
          // BlocListener<NewsBloc, NewsState>(
          //   listener: (context, state) {
          //     if (state is NewsLoadingState) {
          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //         content: const Text(
          //           'Pencarian Sedang Berlangsung',
          //           style: TextStyle(color: Colors.black),
          //         ),
          //         backgroundColor: Colors.amber.shade200,
          //       ));
          //     }
          //     if (state is NewsLoadedState) {
          //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //         content: Text('Pencarian Berhasil'),
          //         backgroundColor: Colors.blue,
          //       ));
          //     }
          //   },
          //   child: BlocBuilder<NewsBloc, NewsState>(
          //     builder: (context, state) {
          //       if (state is NewsLoadingState) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }

          //       if (state is NewsLoadedState) {
          //         return Expanded(
          //           child: ListView.builder(
          //             itemBuilder: (context, index) {
          //               return Card(
          //                 child: ListTile(
          //                   title: Text(state.listNews[index].title!),
          //                   subtitle:
          //                       Text('${state.listNews[index].publishedAt}'),
          //                 ),
          //               );
          //             },
          //             itemCount: state.listNews.length,
          //           ),
          //         );
          //       }

          //       return const Center(
          //         child: Text('No data'),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
