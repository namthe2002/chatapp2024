import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:live_yoko/Service/giphy_get/screen/search_giphy.dart';

import '../../../Controller/Chat/ChatDetailController.dart';
import '../../../core/constant/key/giphy.dart';
import '../client/giphy_client.dart';
import '../model/giphy_collection.dart';
import '../model/giphy_gif_model.dart';

class GiphyTabDetail extends StatefulWidget {
  // final String type;
  final ScrollController scrollController;
  final ChatDetailController chatDetailController;
  const GiphyTabDetail(
      {super.key,
      // required this.type,
      required this.chatDetailController,
      required this.scrollController});

  @override
  _GiphyTabDetailState createState() => _GiphyTabDetailState();
}

class _GiphyTabDetailState extends State<GiphyTabDetail>
    with AutomaticKeepAliveClientMixin {
  // Collection
  GiphyCollection? _collection;

  // List of gifs
  List<GiphyGif> _list = [];

  // Direction
  final Axis _scrollDirection = Axis.vertical;

  // Giphy Client from library
  GiphyClient client = GiphyClient(
      apiKey: KeyPackage.apiKeyGiphyWebsite, randomId: KeyPackage.getRandId());

  final TextEditingController _textEditingController = TextEditingController();

  // Axis count
  late int _crossAxisCount;

  // Spacing between gifs in grid
  double _spacing = 8;

  // Default gif with
  late double _gifWidth;

  // Limit of query
  late int _limit;

  // is Loading gifs
  bool _isLoading = false;

  // Offset
  int offset = 0;

  @override
  void initState() {
    super.initState();
    _gifWidth = 200;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set items count responsive
      _crossAxisCount =
          ((context.size?.width ?? Get.width) / _gifWidth).round();

      // Set vertical max items count
      int _mainAxisCount = ((Get.height - 30) / _gifWidth).round();

      _limit = _crossAxisCount * _mainAxisCount;
      if (_limit > 100) _limit = 100;
      // Initial offset
      offset = 0;

      // Load Initial Data
      _loadMore();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ScrollController
    widget.scrollController.addListener(_scrollListener);

    // Listen query
    _textEditingController.addListener(_listenerQuery);
  }

  @override
  void dispose() {
    // dispose listener
    // Important
    widget.scrollController.removeListener(_scrollListener);
    _textEditingController.removeListener(_listenerQuery);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchAppBar(
          textEditingController: _textEditingController,
          scrollController: widget.scrollController,
          chatDetailController: widget.chatDetailController,
        ),
        _list.isEmpty
            ? Container()
            : Expanded(
                child: MasonryGridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  scrollDirection: _scrollDirection,
                  controller: widget.scrollController,
                  itemCount: _list.length,
                  crossAxisCount: _crossAxisCount,
                  mainAxisSpacing: _spacing,
                  crossAxisSpacing: _spacing,
                  itemBuilder: (ctx, idx) {
                    GiphyGif _gif = _list[idx];
                    return _item(_gif);
                  },
                ),
              ),
      ],
    );
  }

  Widget _item(GiphyGif gif) {
    double aspectRatio = (double.parse(gif.images!.fixedWidth.width) /
        double.parse(gif.images!.fixedWidth.height));

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => _selectedGif(gif),
        child: gif.images == null || gif.images?.fixedWidth.webp == null
            ? Container()
            : ExtendedImage.network(
                gif.images!.fixedWidth.webp!,
                semanticLabel: gif.title,
                cache: true,
                gaplessPlayback: true,
                fit: BoxFit.fill,
                headers: {'accept': 'image/*'},
                loadStateChanged: (state) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: gif.images == null
                      ? Container()
                      : case2(
                          state.extendedImageLoadState,
                          {
                            LoadState.loading: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: Container(
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            LoadState.completed: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: ExtendedRawImage(
                                fit: BoxFit.fill,
                                image: state.extendedImageInfo?.image,
                              ),
                            ),
                            LoadState.failed: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: Container(
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          },
                          AspectRatio(
                            aspectRatio: aspectRatio,
                            child: Container(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                ),
              ),
      ),
    );
  }

  Future<void> _loadMore() async {
    print("Total of collections: ${_collection?.pagination?.totalCount}");
    //Return if is loading or no more gifs
    if (_isLoading || _collection?.pagination?.totalCount == _list.length) {
      print("No more object");
      return;
    }

    _isLoading = true;

    // Offset pagination for query
    if (_collection == null) {
      offset = 0;
    } else {
      offset = _collection!.pagination!.offset + _collection!.pagination!.count;
    }

    print('----------text???:   ${_textEditingController.text}');

    // If query text is not null search gif else trendings

    if (_textEditingController.text.trim().isNotEmpty &&
        _textEditingController.text.trim() != '') {
      _collection = await client.search(_textEditingController.text.trim(),
          offset: offset, limit: _limit);
    } else {
      if (_textEditingController.text.trim() == '') {
        _collection = await client.trending(offset: offset, limit: _limit);
      }
    }

    // Set result to list
    if (_collection != null && (_collection!.data.isNotEmpty && mounted)) {
      setState(() {
        _list.addAll(_collection!.data);
      });
    }

    _isLoading = false;
  }

  // Scroll listener. if scroll end load more gifs
  void _scrollListener() {
    if (widget.scrollController.positions.last.extentAfter <= 500 &&
        !_isLoading) {
      _loadMore();
    }
  }

  // Return selected gif
  void _selectedGif(GiphyGif gif) {
    widget.chatDetailController
        .sendMessage(content: gif.images?.fixedWidth.webp ?? '', type: 8);
  }

  // listener query
  void _listenerQuery() {
    // Reset pagination
    _collection = null;

    // Reset list
    _list = [];

    // Load data
    _loadMore();
  }

  TValue? case2<TOptionType, TValue>(
    TOptionType selectedOption,
    Map<TOptionType, TValue> branches, [
    TValue? defaultValue,
  ]) {
    if (!branches.containsKey(selectedOption)) {
      return defaultValue;
    }

    return branches[selectedOption];
  }

  @override
  bool get wantKeepAlive => true;
}
