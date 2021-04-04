---
layout: post
title: Atomでユーザ補助機能を作るためのモジュール作った
subtitle: Qiitaからの移動
---

Qiitaからの移動

---

[user-support-helper](https://www.npmjs.com/package/atom-user-support-helper)

![](http://hiroakimikami.github.io/atom-user-support-helper/interactive-configuration-panel.gif)

Atomパッケージの初期設定などの支援機能を作るためのモジュールを作った．
初期設定が必要なパッケージってそれなりの数あると思う．[自分のパッケージ](http://qiita.com/MikamiHiroaki/items/7620023e6a870ac17e90)におけるMS TranslatorのIDとSecretとか，pandocを使うパッケージにおけるpandocのパスとか．しかし，そのうち大半（自分の知る限り全て）のパッケージでは，そういった初期設定はREADMEを見ながら，Settings画面から自分で設定する以外の方法がない．
そのため，

1. 自分でインストールしたパッケージに追加する設定を見落として暫く悩む．
2. [translator-plus-dictionary](https://atom.io/packages/translator-plus-dictionary)に「翻訳動かないんだけど」って問い合わせがあってエラーメッセージ見るとIDとSecretの登録がされていない．

のような問題が起きてしまっていた．これへの対応策として，初期設定パネルなどを作るモジュールを作った（上Screenshot参考）．必要な設定がなされてない時，エラーメッセージが出るのではなく，このようなパネルが出て，interactiveに初期設定ができる方が便利でないかなと．

このようなユーザ補助機能を実装するのは面倒で，後回しにされがちだと思うので（少なくとも自分は後回しにする），機能よりも記述するコード量が少なくなることを優先して実装したつもり．例えば，pandocのパスが必要なら，

```javascript
const panel = new UserSUpportHelper().getInteractiveConfigurationPanel()
panel.add('package-name.pandocPath', {
  type: 'input',
  name: 'The path of the pandoc command'
})

if (!atom.config.get('package-name.pandocPath')) {
  panel.show(['package-name.pandoncPath'])
}

```

のように書けば以下のようなパネルが表示される（translator-plus-dictionaryでは設定項目が5つもあるので数十行の記述が必要だった）．

![example.png](https://qiita-image-store.s3.amazonaws.com/0/111070/989438f3-6650-40a6-b90b-279f257ad64c.png)

基本的に自分が使いたいから作ったパッケージですが，Atomパッケージ書く人で使いたいなと思う人がいたら是非使ってやってください．
