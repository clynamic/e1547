import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests the functions that map stable english names, the keys that data
/// sources like [PostParams.tagsFilter] use, to their localized display names.
///
/// Asserting every case against the values of the app arb files keeps the
/// mappings from silently drifting away from their data sources, and the
/// self-reflection of the english values keeps renamed keys from breaking the
/// mappings unnoticed.
void main() {
  /// Runs [probe] during a build below a [MaterialApp] in [locale].
  Future<void> pumpLocale(
    WidgetTester tester,
    Locale locale,
    void Function(BuildContext context) probe,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            probe(context);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  testWidgets('filter names localize to chinese', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      for (final (name, zh, _) in _filterNames) {
        expect(localizedFilterName(context, name), zh, reason: name);
      }
    });
  });

  testWidgets('filter names localize to traditional chinese', (tester) async {
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        for (final (name, _, hant) in _filterNames) {
          expect(localizedFilterName(context, name), hant, reason: name);
        }
      },
    );
  });

  testWidgets('filter names map their english keys to themselves', (
    tester,
  ) async {
    await pumpLocale(tester, const Locale('en'), (context) {
      for (final (name, _, _) in _filterNames) {
        expect(localizedFilterName(context, name), name, reason: name);
      }
    });
  });

  testWidgets('filter names pass unknown names through', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      expect(localizedFilterName(context, 'Unknown filter'), 'Unknown filter');
    });
  });

  testWidgets('drawer destinations localize to chinese', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      for (final (name, zh, _) in _destinationNames) {
        expect(localizedDestinationName(context, name), zh, reason: name);
      }
    });
  });

  testWidgets('drawer destinations localize to traditional chinese', (
    tester,
  ) async {
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        for (final (name, _, hant) in _destinationNames) {
          expect(localizedDestinationName(context, name), hant, reason: name);
        }
      },
    );
  });

  testWidgets('drawer destinations pass unknown names through', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      expect(
        localizedDestinationName(context, 'Unknown destination'),
        'Unknown destination',
      );
    });
  });

  testWidgets('history categories localize to chinese', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      expect(localizedHistoryCategory(context, HistoryCategory.items), '浏览');
      expect(localizedHistoryCategory(context, HistoryCategory.searches), '搜索');
    });
  });

  testWidgets('history categories localize to traditional chinese', (
    tester,
  ) async {
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        expect(localizedHistoryCategory(context, HistoryCategory.items), '瀏覽');
        expect(
          localizedHistoryCategory(context, HistoryCategory.searches),
          '搜尋',
        );
      },
    );
  });

  testWidgets('history types localize to chinese', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      expect(localizedHistoryType(context, HistoryType.posts), '帖子');
      expect(localizedHistoryType(context, HistoryType.pools), '图集');
      expect(localizedHistoryType(context, HistoryType.topics), '讨论');
      expect(localizedHistoryType(context, HistoryType.wikis), '维基');
      expect(localizedHistoryType(context, HistoryType.users), '用户');
    });
  });

  testWidgets('history types localize to traditional chinese', (tester) async {
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        expect(localizedHistoryType(context, HistoryType.posts), '貼文');
        expect(localizedHistoryType(context, HistoryType.pools), '圖集');
        expect(localizedHistoryType(context, HistoryType.topics), '討論');
        expect(localizedHistoryType(context, HistoryType.wikis), '維基');
        expect(localizedHistoryType(context, HistoryType.users), '使用者');
      },
    );
  });

  testWidgets('tag category names localize', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      for (final (name, zh, _) in _tagCategoryNames) {
        expect(localizedTagCategoryName(context, name), zh, reason: name);
      }
      // unknown categories fall back to their capitalized name
      expect(localizedTagCategoryName(context, 'unknown'), 'Unknown');
    });
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        for (final (name, _, hant) in _tagCategoryNames) {
          expect(localizedTagCategoryName(context, name), hant, reason: name);
        }
      },
    );
  });

  testWidgets('rating names localize', (tester) async {
    await pumpLocale(tester, const Locale('zh'), (context) {
      expect(localizedRatingName(context, Rating.s), '安全');
      expect(localizedRatingName(context, Rating.q), '存疑');
      expect(localizedRatingName(context, Rating.e), '露骨');
    });
    await pumpLocale(
      tester,
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      (context) {
        expect(localizedRatingName(context, Rating.s), '安全');
        expect(localizedRatingName(context, Rating.q), '存疑');
        expect(localizedRatingName(context, Rating.e), '露骨');
      },
    );
  });
}

/// The cases of [localizedFilterName]'s switch that assert against the
/// chinese and traditional chinese display names of the app arb files.
///
/// 'Oldest' is covered by dedicated order tests instead. These names double
/// as stable keys, keep them in sync with the data sources that use them,
/// like [PostParams.tagsFilter] and the topic page's filters.
const List<(String, String, String)> _filterNames = [
  ('Score', '评分', '評分'),
  ('Favorite count', '收藏数', '收藏數'),
  ('Sort by', '排序方式', '排序方式'),
  ('New', '最新', '最新'),
  ('Favorites', '收藏', '收藏'),
  ('Rank', '排名', '排名'),
  ('Random', '随机', '隨機'),
  ('Default', '默认', '預設'),
  ('Rating', '分级', '分級'),
  ('Safe', '安全', '安全'),
  ('Questionable', '存疑', '存疑'),
  ('Explicit', '露骨', '露骨'),
  ('All', '全部', '全部'),
  ('Pool', '图集', '圖集'),
  ('Has pool', '含图集', '含圖集'),
  ('Child', '子帖', '子貼文'),
  ('Is child post', '是子帖', '是子貼文'),
  ('Parent', '父帖', '父貼文'),
  ('Is parent post', '是父帖', '是父貼文'),
  ('Upload date', '上传日期', '上傳日期'),
  ('Last day', '最近一天', '最近一天'),
  ('Last week', '最近一周', '最近一週'),
  ('Last Month', '最近一个月', '最近一個月'),
  ('Last Year', '最近一年', '最近一年'),
  ('Status', '状态', '狀態'),
  ('Active', '活跃', '活躍'),
  ('Pending', '待处理', '待處理'),
  ('Deleted', '已删除', '已刪除'),
  ('Flagged', '已标记', '已標記'),
  ('Any', '任意', '任意'),
  ('Title contains', '标题包含', '標題包含'),
  ('Category', '分类', '分類'),
  ('General', '综合', '一般'),
  ('Site Bug Reports & Feature Requests', '站点问题反馈与功能请求', '網站問題與功能請求'),
  ('Tag/Wiki Projects and Questions', '标签/维基项目与提问', '標籤/維基專案與提問'),
  ('Tag Alias and Implication Suggestions', '标签别名与关联建议', '標籤別名與關聯建議'),
  ('Art Talk', '艺术交流', '藝術交流'),
  ('Off Topic', '跑题', '離題'),
  ('e621 Tools and Applications', 'e621 工具与应用', 'e621 工具與應用程式'),
  ('Newest first', '最新优先', '最新優先'),
  ('Oldest first', '最旧优先', '最舊優先'),
  ('Sticky', '置顶', '置頂'),
  ('Is sticky', '已置顶', '已置頂'),
  ('Locked', '已锁定', '已鎖定'),
  ('Is locked', '已锁定', '已鎖定'),
  ('Description', '描述', '描述'),
  ('Creator', '创建者', '建立者'),
  ('Is active', '活跃中', '活躍中'),
  ('Series', '系列', '系列'),
  ('Collection', '合集', '合輯'),
  ('Name', '名称', '名稱'),
  ('Created', '创建时间', '建立時間'),
  ('Updated', '更新时间', '更新時間'),
  ('Post count', '帖子数', '貼文數'),
  ('File type', '文件类型', '檔案類型'),
  ('Uploader', '上传者', '上傳者'),
  ('Width', '宽度', '寬度'),
  ('Height', '高度', '高度'),
  ('Tag count', '标签数', '標籤數'),
  ('True', '是', '是'),
  ('False', '否', '否'),
  ('Images', '图片', '圖片'),
  ('Videos', '视频', '影片'),
  ('Tags', '标签', '標籤'),
];

/// Every case of [localizedDestinationName]'s switch, with its chinese and
/// traditional chinese display names.
const List<(String, String, String)> _destinationNames = [
  ('Home', '首页', '首頁'),
  ('Hot', '热门', '熱門'),
  ('Search', '搜索', '搜尋'),
  ('Favorites', '收藏', '收藏'),
  ('Timeline', '时间线', '時間軸'),
  ('Subscriptions', '订阅', '訂閱'),
  ('Bookmarks', '书签', '書籤'),
  ('Pools', '图集', '圖集'),
  ('Forum', '论坛', '論壇'),
  ('History', '历史', '歷史'),
  ('Tasks', '任务', '任務'),
  ('Settings', '设置', '設定'),
  ('About', '关于', '關於'),
];

/// Every case of [localizedTagCategoryName]'s switch, with its chinese and
/// traditional chinese display names.
const List<(String, String, String)> _tagCategoryNames = [
  ('general', '通用', '一般'),
  ('species', '物种', '物種'),
  ('character', '角色', '角色'),
  ('copyright', '版权', '版權'),
  ('meta', '元信息', '中繼資訊'),
  ('lore', '背景设定', '背景設定'),
  ('artist', '画师', '繪師'),
  ('contributor', '贡献者', '貢獻者'),
  ('invalid', '无效', '無效'),
];
