---
layout: post
title: CoffeeScriptでPromiseを使ったときにハマった
subtitle: Qiitaからの移動
---

Qiitaからの移動

---

Atomのプラグインを書こうとして，CoffeeScriptを書いていたら`Promise`の使用中にハマった．
もう既に誰かが踏んだ地雷な気がするし，Qiitaに記事があると思ったが，見つからなかったのでメモがてら残しておく．

# やりたい事とコード
CoffeeScriptを使って，次のような`Promise`の使用をしたかった．

1. `then`の引数関数内で，メンバへのアクセスをする
2. `then`の引数関数内で，`resolve`，`reject`を使う

`then`内で，非同期APIの結果の例外処理(JSON，DOMのパースなど)をして，さらに，成功時はメンバへアクセスして処理をするような感じで，例えば，次のようなコード（`Promise`の必要がないコードだが，例という事で）

```CoffeeScript
class Class
  n: 2

  func: ->
    new Promise(
      (resolve) -> resolve(10)
    ).then(
      (value) ->
        if value is 0
          reject("value is 0")
        else
          resolve(value * @n)
    ).then((value) -> console.log(value + " #result"))
```

が，これを動かすと，`@n`が`undefined`となり（CoffeeScriptの仕様への自分の理解が正しければ当然），**コンソールには`NaN #result`が表示**されてしまう．

こういうcallbackを簡単にかくために，CoffeeScriptには`=>`という記法があるので，これを使うと次のように書ける．

```CoffeeScript
class Class
  n: 2

  func: ->
    new Promise(
      (resolve) -> resolve(10)
    ).then(
      (value) =>
        if value is 0
          reject("value is 0")
        else
          resolve(value * @n)
    ).then((value) -> console.log(value + " #result"))
```

しかし，今度は`Uncaught (in promise) ReferenceError: resolve is not defined`というエラーメッセージが表示される．
あまりちゃんと調べていないが，`resolve`は，`this.resolve`の意味であり，`=>`によって`this`の動きが変わっているのだろう．

# 実験
どういうふうに書けば適切な動作をするのかを調べるべく，書き方を思いつく限り試して見た所，次のような結果になった．結局，`new Promise`を使って記述するのが今回の場合は最善なのかな．

## 上手く動くコード
```coffeescript
then((value) -> value)
then((value) => value * @n)
then((value) => new Promise((resolve, reject) => resolve(value * @n))
```

## メンバにアクセス出来ずに変な動作をするコード
```coffeescript
then((value) -> value * @n)
```
## ReferenceErrorが起こるコード
```coffeescript
(value) => resolve(value * @n)
```

# 最後に
他にもっと簡単な解決策があれば教えて頂けると嬉しいです．CoffeeScriptは触り始めたばっかりなので．
