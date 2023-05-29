import 'package:flutter/material.dart';

class Ai_WriteDiary extends StatefulWidget {
  const Ai_WriteDiary({Key? key}) : super(key: key);

  @override
  State<Ai_WriteDiary> createState() => _Ai_WriteDiaryState();
}

class _Ai_WriteDiaryState extends State<Ai_WriteDiary> {
  List<TagModel> _tags = [];
  TextEditingController _searchTextEditingController =
  new TextEditingController();

  String get _searchText => _searchTextEditingController.text.trim();

  final List<TagModel> _tagsToSelect = [
    TagModel(id: '1', title: 'JavaScript'),
    TagModel(id: '2', title: 'Python'),
    TagModel(id: '3', title: 'Java'),
    TagModel(id: '4', title: 'PHP'),
    TagModel(id: '5', title: 'C#'),
    TagModel(id: '6', title: 'C++'),
    TagModel(id: '7', title: 'Dart'),
    TagModel(id: '8', title: 'DataFlex'),
    TagModel(id: '9', title: 'Flutter'),
    TagModel(id: '10', title: 'Flutter Selectable Tags'),
    TagModel(id: '11', title: 'Android Studio developer'),
  ];
  refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() => refreshState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  List<TagModel> _filterSearchResultList() {
    if (_searchText.isEmpty) return _tagsToSelect;

    List<TagModel> _tempList = [];
    for (int index = 0; index < _tagsToSelect.length; index++) {
      TagModel tagModel = _tagsToSelect[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  _addTags(tagModel) async {
    if (!_tags.contains(tagModel))
      setState(() {
        _tags.add(tagModel);
      });
  }

  _removeTag(tagModel) async {
    if (_tags.contains(tagModel)) {
      setState(() {
        _tags.remove(tagModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tagIcon(),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_offer_outlined,
          color: Colors.deepOrangeAccent,
          size: 25.0,
        ),
        _tagsWidget(),
      ],
    );
  }

  _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : Text('No Labels added'),
    );
  }

  Widget _buildSuggestionWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_filterSearchResultList().length != _tags.length) Text('Suggestions'),
      Wrap(
        alignment: WrapAlignment.start,
        children: _filterSearchResultList()
            .where((tagModel) => !_tags.contains(tagModel))
            .map((tagModel) => tagChip(
          tagModel: tagModel,
          onTap: () => _addTags(tagModel),
          action: 'Add',
        ))
            .toList(),
      ),
    ]);
  }

  Widget tagChip({
    tagModel,
    onTap,
    action,
  }) {
    return InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Text(
                  '${tagModel.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.orange.shade600,
                radius: 8.0,
                child: Icon(
                  Icons.clear,
                  size: 10.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 10.0,
        bottom: 10.0,
      ),
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        border: Border.all(
          color: Colors.grey.shade500,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchTextEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Search Tag',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                fontSize: 16.0,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          _searchText.isNotEmpty
              ? InkWell(
            child: Icon(
              Icons.clear,
              color: Colors.grey.shade700,
            ),
            onTap: () => _searchTextEditingController.clear(),
          )
              : Icon(
            Icons.search,
            color: Colors.grey.shade700,
          ),
          Container(),
        ],
      ),
    );
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tags',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          _tags.length > 0
              ? Column(children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: _tags
                  .map((tagModel) => tagChip(
                tagModel: tagModel,
                onTap: () => _removeTag(tagModel),
                action: 'Remove',
              ))
                  .toSet()
                  .toList(),
            ),
          ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }
}

class TagModel {
  String id;
  String title;

  TagModel({
    required this.id,
    required this.title,
  });
}
