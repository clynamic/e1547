const List<String> tagCategoryNames = [
  'general',
  'artist',
  'contributor',
  'copyright',
  'character',
  'species',
  'invalid',
  'meta',
  'lore',
];

const List<String> metatagNames = [
  'md5',
  'order',
  'limit',
  'child',
  'randseed',
  'ratinglocked',
  'notelocked',
  'statuslocked',
  'id',
  'filetype',
  'type',
  'rating',
  'description',
  'parent',
  'user',
  'user_id',
  'approver',
  'flagger',
  'deletedby',
  'delreason',
  'source',
  'status',
  'pool',
  'set',
  'search',
  'fav',
  'favoritedby',
  'note',
  'locked',
  'upvote',
  'votedup',
  'upvoted',
  'voteup',
  'downvote',
  'voteddown',
  'downvoted',
  'votedown',
  'voted',
  'vote',
  'width',
  'height',
  'mpixels',
  'ratio',
  'filesize',
  'duration',
  'score',
  'favcount',
  'date',
  'age',
  'change',
  'tagcount',
  'commenter',
  'comm',
  'noter',
  'noteupdater',
  'flagreason',
  'flagnote',
  'flaggedby',
  'gentags',
  'arttags',
  'conttags',
  'copytags',
  'chartags',
  'spectags',
  'invtags',
  'metatags',
  'lortags',
  'comment_count',
  'hassource',
  'hasdescription',
  'isparent',
  'ischild',
  'hasparent',
  'haschild',
  'haschildren',
  'inpool',
  'pending_replacements',
  'artverified',
];

const List<String> orderMetatagValues = [
  'random',
  'hot',
  'general_tags',
  'general_tags_asc',
  'artist_tags',
  'artist_tags_asc',
  'contributor_tags',
  'contributor_tags_asc',
  'copyright_tags',
  'copyright_tags_asc',
  'character_tags',
  'character_tags_asc',
  'species_tags',
  'species_tags_asc',
  'invalid_tags',
  'invalid_tags_asc',
  'meta_tags',
  'meta_tags_asc',
  'lore_tags',
  'lore_tags_asc',
  'id',
  'id_desc',
  'score',
  'score_asc',
  'md5',
  'md5_asc',
  'favcount',
  'favcount_asc',
  'note',
  'note_asc',
  'mpixels',
  'mpixels_asc',
  'filesize',
  'filesize_asc',
  'tagcount',
  'tagcount_asc',
  'change',
  'change_asc',
  'duration',
  'duration_asc',
  'created',
  'created_asc',
  'updated',
  'updated_asc',
  'comment',
  'comment_asc',
  'comment_bumped',
  'comment_bumped_asc',
  'deleted',
  'deleted_asc',
  'flagged',
  'flagged_asc',
  'comment_count',
  'comment_count_asc',
  'portrait',
  'landscape',
];

const List<String> fileTypeMetatagValues = [
  'jpg',
  'png',
  'gif',
  'swf',
  'webm',
  'mp4',
  'webp',
];

const Map<String, List<String>> staticMetatagValues = {
  'order': orderMetatagValues,
  'status': ['any', 'deleted', 'active', 'pending', 'flagged', 'modqueue'],
  'rating': ['safe', 'questionable', 'explicit'],
  'locked': ['rating', 'note', 'status'],
  'child': ['any', 'none'],
  'parent': ['any', 'none'],
  'filetype': fileTypeMetatagValues,
  'type': fileTypeMetatagValues,
};

const Map<String, String> fileTypeAliases = {'flash': 'swf'};

const Set<String> userMetatagNames = {
  'user',
  'approver',
  'commenter',
  'comm',
  'noter',
  'noteupdater',
  'fav',
  'favoritedby',
  'flagger',
  'flaggedby',
  'deleter',
  'deletedby',
  'upvote',
  'downvote',
};

const int metatagSuggestionLimit = 10;

const int suggestionMinLength = 3;

class TagSuggestion {
  const TagSuggestion({
    required this.name,
    this.category,
    this.count,
    this.complete = true,
  });

  final String name;
  final int? category;
  final int? count;
  final bool complete;
}

typedef MetatagTerm = ({String prefix, String? metatag, String value});

MetatagTerm splitMetatagTerm(String term) {
  final String prefix = RegExp('^[-~]*').stringMatch(term) ?? '';
  final String rest = term.substring(prefix.length);
  final int colon = rest.indexOf(':');
  if (colon > 0) {
    final String name = rest.substring(0, colon).toLowerCase();
    if (metatagNames.contains(name) ||
        userMetatagNames.contains(name) ||
        tagCategoryNames.contains(name)) {
      return (prefix: prefix, metatag: name, value: rest.substring(colon + 1));
    }
  }
  return (prefix: prefix, metatag: null, value: rest);
}

List<String> staticMetatagMatches(String metatag, String value) {
  final List<String>? options = staticMetatagValues[metatag];
  if (options == null) return const [];
  String typed = value.trim().toLowerCase();
  if (metatag == 'filetype' || metatag == 'type') {
    typed = fileTypeAliases[typed] ?? typed;
  }
  final List<String> matches = [
    for (final String option in options)
      if (typed.isEmpty || option.startsWith(typed)) '$metatag:$option',
  ]..sort();
  return matches.take(metatagSuggestionLimit).toList();
}

List<String> metatagNameMatches(String typed) {
  final String value = typed.trim().toLowerCase();
  if (value.length < suggestionMinLength) return const [];
  return [
    for (final String name in metatagNames)
      if (name.startsWith(value)) '$name:',
  ];
}
