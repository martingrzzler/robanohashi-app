import 'package:flutter/material.dart';

import 'search/search_delegate.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Roba no hashi",
      ),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: DictionarySearchDelegate());
          },
          icon: const Icon(Icons.search),
        )
      ],
    );
  }
}
