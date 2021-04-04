---
layout: post
title: Makerbot DesktopをDocker上で起動するイメージを作った
subtitle: Qiitaからの移動
---

Qiitaからの移動

---

docker-makerbot-desktop: [DockerHub](https://hub.docker.com/r/mhiroaki8270/docker-makerbot-desktop/), [GitHub](https://github.com/HiroakiMikami/docker-makerbot-desktop)

[Makerbot Desktop](https://www.makerbot.com/desktop)を使いたい，とふと思ったが，わざわざそのためにUbuntuを入れたり，無理やりArch Linuxにインストールはしたくなかったので，Docker上で動かすことを考えた．
しかし，Githubにあったいくつかのレポジトリは，自分の環境では上手く動かなかったり，Dockerhubにあがっていなかったので，自作した．

動作については，上記DockerHubやGitHubにあるReadmeの通りなので割愛して，これを作った時にハマった点，思った点をメモ．

# Docker上のGUIアプリケーション
ググると色々方法はでるが，X Window Systemを利用しているならこれを使うのが最も単純だと思う([参考](http://postd.cc/running-gui-apps-with-docker/))．

ただ，上の方法そのままだと`No protocol specified`と言われて，起動できなかった．dockerのコンテナは結局rootユーザで起動されるので，

```bash
$ xhost local:root
```

として，rootからのX Windowのアクセスを許可すればいい(のだと思う)．
正直，X Window Systemの話はあまりちゃんと勉強していないので違うかもしれない．

# 解決できていない問題点
上記の通り，docker daemonはrootユーザで起動されているので，コンテナもrootユーザで起動されてしまう．従って，Makerbot Desktopがホストから見るとrootで起動されている事になる．

サーバサイドであれば，大半のアプリケーション(`httpd`等)にroot権限が何かしら必要なので，この点は問題にはならなかったのだろうと思う．しかし，GUIアプリケーションなどのクライアントアプリケーションやソフトウェア開発環境をdockerを使って起動する場合には，迷惑だし怖い．

クライアントアプリケーションのdockerによる管理をするなら，この点は解決したいところだなぁと思う．
が，解決策はググっても見つからなかったのでとりあえずこれで公開した．
