---
layout: post
title: Atomで翻訳系API呼び出すパッケージを作った
subtitle: Qiitaからの移動
---

Qiitaからの移動

---

[translator-plus-dictionary](https://atom.io/packages/translator-plus-dictionary)

翻訳API(主にMS Translator)と辞書API(主にデ辞蔵)をAtom.ioから使うためのパッケージを作った．既存パッケージにもある(MS Translator)のは事実だが，見た目・機能が気に食わなかったので自作した．
言語の自動認識でショートカットだけで日本語から英語，英語から日本語に翻訳するくらいはできるようになったので自分としては満足．英語論文を書く時とかにはそれなりに便利になったのではと思っている．

基本的には書きやすいプラグインだったが，いくつか詰まった所があったのでそれについては別途投稿するつもり．

---

(2016/8/31追記)
[この記事](http://qiita.com/MikamiHiroaki/items/4d674122485cf1eec521)の自作モジュールを使って，MS TranslatorのIDやSecretなど必要なconfigが無い時に設定パネルを出すようにしました．
