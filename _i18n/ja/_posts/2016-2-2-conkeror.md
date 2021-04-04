---
layout: post
title: Conkeror(Webブラウザ)で終了時のバッファの保存，復元をする
subtitle: Qiitaからの移動
---

Qiitaからの移動

---

Webブラウザとして良く[conkeror](http://conkeror.org/)を使い始めたのだが，前回終了時のバッファ(いわゆるタブ)を保存することがデフォルトではできない．
公式のWikiや適当にググった結果を見る限り，そのような設定ファイルは見つからなかったので，自分で書いてみた．

## Conkerorとは
Mozilla XULRunnerをベースにしたWebブラウザで，

* CUI/TUIでの利用がベース
* Emacsとかviのように，設定ファイルで動作をカスタマイズ可能

という特徴がある．KeySnailが使えなくなる日に備えて徐々にconkerorへの移動を自分は開始してみたが，まだまだ先は長い．

## 設定ファイル
```javascript
/**
 * The browser restore the windows and buffers from last time.
 */
var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);

var startup_filename = ".conkeror_startup";
var startup_file = get_home_directory();

startup_file.append(startup_filename);

function can_restore_windows_and_buffers() {
  var count = 0;
  var flag = true;
  for_each_buffer(function (buffer) {
    count += 1;

    var uri = buffer.current_uri.resolve(null);
    if (uri != null && uri != homepage) {
      flag = false;
    }
  });
  return count <= 1 && flag;
}

function should_save_windows_and_buffers() {
  var count = 0;
  for_each_window(function (w) {
    count += 1;
  });
  // if the number of windows is 1, save windows and buffers.
  return count == 1;
}
/* save windows and buffers */
function save_windows_and_buffers() {
  try {
    var windows = [];
    for_each_window(function (w) {
      var buffers = [];
      w.buffers.for_each(function (buffer) {
        buffers.push(buffer.current_uri.resolve(null));
      });
      windows.push(buffers);
    });

    var data = JSON.stringify(windows);

    /* write file
    (https://developer.mozilla.org/ja/docs/Code_snippets/File_I_O#.E3.83.95.E3.82.A1.E3.82.A4.E3.83.AB.E3.81.AB.E6.9B.B8.E3.81.8D.E5.87.BA.E3.81.99)
    */
    var foStream = Components.classes["@mozilla.org/network/file-output-stream;1"]
                       .createInstance(Components.interfaces.nsIFileOutputStream);
    foStream.init(startup_file, 0x02 | 0x08 | 0x20, 0664, 0);
    foStream.write(data, data.length);
    foStream.close();
  } catch (e) {
    dumpln("Error in save buffers: " + e);
  }
}

// add hook to save the windows and buffers when the conkeror exit.
add_hook("quit_hook", save_windows_and_buffers);
add_hook("window_before_close_hook", function(w) {
  if (should_save_windows_and_buffers()) {
    save_windows_and_buffers();
  }
  return true;
});

if (!startup_file.exists()) {
  return ;
}

/* read file
(https://developer.mozilla.org/ja/docs/Code_snippets/File_I_O#.E3.83.95.E3.82.A1.E3.82.A4.E3.83.AB.E3.81.AB.E6.9B.B8.E3.81.8D.E5.87.BA.E3.81.99)
*/
var data = "";
var fstream = Components.classes["@mozilla.org/network/file-input-stream;1"]
                        .createInstance(Components.interfaces.nsIFileInputStream);
var sstream = Components.classes["@mozilla.org/scriptableinputstream;1"]
                        .createInstance(Components.interfaces.nsIScriptableInputStream);
fstream.init(startup_file, -1, 0, 0);
sstream.init(fstream);
var str = sstream.read(4096);
while (str.length > 0) {
  data += str;
  str = sstream.read(4096);
}
sstream.close();
fstream.close();

var windows = JSON.parse(data);

add_hook("window_initialize_late_hook", function(w) {
  if (!can_restore_windows_and_buffers()) return ;

  var buffer = null;
  w.buffers.for_each(function(b) {
    buffer = b;
  });

  if (buffer == null) return ;

  for (var i = 0, l1 = windows.length; i < l1; i++) {
    var window = windows[i];
    for (var j = 0, l2 = window.length; j < l2; j++) {
      var uri = ioService.newURI(window[j], null, null);
      if (j == 0) {
        if (i != 0) {
          browser_object_follow(buffer, OPEN_NEW_WINDOW, uri.spec);
        } else {
          browser_object_follow(buffer, OPEN_CURRENT_BUFFER, uri.spec);
        }
      } else {
        browser_object_follow(buffer, OPEN_NEW_BUFFER, uri.spec);
      }
    }
  }
});
```

`${HOME}/.conkeror_startup`ファイルに，前回終了時のバッファ一覧が保存され，起動時にはそのファイルを読んで復元するようになっている．
書いているときにハマったのは，

1. conkerorの終了は，次の2つのhookを併用して検出する必要がある(ここが結構ハマった)．
    * `quit_hook`
        * `C-x C-c`等での終了時のhook
    * `window_before_close_hook`が呼び出され，かつ，windowの個数が1個
        * 何らかの手段で，最後のwindowを閉じたときのhook
2. スクリプトが呼び出されているタイミングでは，まだwindowは初期化されていない
    * `window_initialize_late_hook`を使って，windowが開かれたときに復元処理を行う必要がある

の2箇所．この2点を除けば難しいところのないスクリプトだったし，参考URLはコメントで載せてあるので説明は省く．
