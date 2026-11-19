import 'package:e1547/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a folder picked on internal storage reads as its path there', () {
    expect(
      FileDownloader.displayPath(
        'content://com.android.externalstorage.documents/tree/'
        'primary%3APictures/document/primary%3APictures%2Fe1547',
      ),
      'Pictures/e1547',
    );
    expect(
      FileDownloader.displayPath(
        'content://com.android.externalstorage.documents/tree/'
        'primary%3ADownload',
      ),
      'Download',
    );
  });

  test('internal storage itself reads by name', () {
    expect(
      FileDownloader.displayPath(
        'content://com.android.externalstorage.documents/tree/primary%3A',
      ),
      'Internal storage',
    );
  });

  test('a folder on another volume reads with that volume in front', () {
    expect(
      FileDownloader.displayPath(
        'content://com.android.externalstorage.documents/tree/'
        '1A2B-3C4D%3ADCIM%2FCamera',
      ),
      '1A2B-3C4D/DCIM/Camera',
    );
  });

  test('a folder picked in the downloads list reads as its path', () {
    expect(
      FileDownloader.displayPath(
        'content://com.android.providers.downloads.documents/tree/'
        'raw%3A%2Fstorage%2Femulated%2F0%2FDownload%2Fe1547',
      ),
      '/storage/emulated/0/Download/e1547',
    );
  });

  test('a desktop folder reads as it was picked', () {
    for (final String path in [
      r'C:\Users\tester\Pictures',
      '/home/tester/100% done',
      '/home/tester/tree/a:b',
    ]) {
      expect(FileDownloader.displayPath(path), path);
    }
  });
}
