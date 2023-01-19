import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_notes/src/providers/tasks.dart';
import 'package:smart_notes/src/providers/widget_visibility.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();

  static const routeName = '/tasks';
}

class _TasksScreenState extends State<TasksScreen> {
  final background = const AssetImage("assets/images/backgrounds/00012.png");

  // void searchTags(String query) {
  //   final tasksData = Provider.of<Tasks>(context, listen: false);
  //   final tags = tasksData.tags;
  //
  //   final suggestions =
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: background, fit: BoxFit.fill),
          ),
        ),
        Builder(
          builder: (context) {
            return const CustomScrollView(
              slivers: [
                TitlePanel(),
                // FavouriteFiltersTab(),
                SliverToBoxAdapter(
                  child: FiltersWrap(),
                ),
                TasksList(),
              ],
            );
          },
        ),
      ]),
    );
  }
}

class FilterSearchPanel extends StatefulWidget {
  const FilterSearchPanel({Key? key}) : super(key: key);

  @override
  State<FilterSearchPanel> createState() => _FilterSearchPanelState();
}

class _FilterSearchPanelState extends State<FilterSearchPanel> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final visibilityData = Provider.of<WidgetVisibility>(context);
    final searchVisibility = visibilityData.showSearch;

    return Container(
      child: searchVisibility
          ? Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                Radius.circular(25),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  FilterSearchBar(),
                ],
              ),
            )
          : null,
    );
  }
}

class FavouriteFiltersTab extends StatefulWidget {
  const FavouriteFiltersTab({Key? key}) : super(key: key);

  @override
  State<FavouriteFiltersTab> createState() => _FavouriteFiltersTabState();
}

class _FavouriteFiltersTabState extends State<FavouriteFiltersTab> {
  final _collapsedArrow = Icons.arrow_drop_down_rounded;
  final _expandedArrow = Icons.arrow_drop_up_rounded;
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _expanded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const FiltersWrap(),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: Icon(
                      _expandedArrow,
                      size: 50,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 250,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FiltersWrap(),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      child: Icon(
                        _collapsedArrow,
                        size: 50,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class FilterSearchBar extends StatelessWidget {
  const FilterSearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visibilityData = Provider.of<WidgetVisibility>(context);
    final enabled = visibilityData.showSuggestedTags;

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 2),
                child: TextField(
                  onTap: () {
                    visibilityData.enableSuggestedTags();
                  },
                  onEditingComplete: () {
                    visibilityData.disableSuggestedTags();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.25),
                    isCollapsed: true,
                    hintStyle: const TextStyle(fontSize: 25),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                )),
            enabled
                ? const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: FiltersWrap(),
                  )
                : Container()
          ],
        ),
      )
    ]);
  }
}

class TitlePanel extends StatefulWidget {
  const TitlePanel({
    Key? key,
  }) : super(key: key);

  @override
  State<TitlePanel> createState() => _TitlePanelState();
}

class _TitlePanelState extends State<TitlePanel> {
  @override
  Widget build(BuildContext context) {
    final visibilityData = Provider.of<WidgetVisibility>(context);
    final displaySearch = visibilityData.showSearch;

    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.25),
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(35),
        bottomRight: Radius.circular(35),
      )),
      floating: true,
      title: const Text(
        "Your Tasks",
        textScaleFactor: 1.5,
      ),
      actions: const [SearchButton()],
    );
  }
}

class SearchButton extends StatefulWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  var _enabled = false;

  @override
  Widget build(BuildContext context) {
    final visibilityData = Provider.of<WidgetVisibility>(context);

    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: _enabled
                ? Colors.deepPurple
                : Colors.deepPurple.withOpacity(0.3),
            shape: BoxShape.circle),
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            visibilityData.toggleSearch();
            setState(() {
              _enabled = !_enabled;
            });
          },
          child: const Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}

class FiltersWrap extends StatefulWidget {
  const FiltersWrap({
    Key? key,
  }) : super(key: key);

  @override
  State<FiltersWrap> createState() => _FiltersWrapState();
}

class _FiltersWrapState extends State<FiltersWrap> {
  final tagsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context, listen: true);
    final tags = tasksData.tags;
    final enabledTags = tasksData.enabledTags;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Wrap(
        spacing: 2,
        runSpacing: -10,
        children: List.generate(
            tags.length,
            (index) => FilterChip(
                shadowColor: Colors.transparent,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.25),
                selectedColor: Colors.white.withOpacity(0.25),
                label: Text(tags[index]),
                checkmarkColor: Colors.white,
                selected: enabledTags.contains(tags[index]),
                onSelected: (val) {
                  if (val) {
                    tasksData.enableTag(tags[index]);
                    tasksData.filterNotes();
                  } else {
                    tasksData.disableTag(index);
                    tasksData.removeFilter(tags[index]);
                  }
                })),
      ),
    );
  }
}

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<Tasks>(context);
    final tasks = taskData.tasks;
    final enabledTags = taskData.enabledTags;
    final filteredNoteList = taskData.filteredNotesList;

    if (enabledTags.isEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: tasks.length,
          (context, index) => Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.25),
            child: ListTile(
              title: Text(tasks[index].note.text),
              subtitle: Text(
                tasks[index].note.tags,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: filteredNoteList.length,
          (context, index) => Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.25),
            child: ListTile(
              title: Text(filteredNoteList[index].note.text),
              subtitle: Text(
                filteredNoteList[index].note.tags,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),
        ),
      );
    }
  }
}
