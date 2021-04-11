---
layout: post
title: Deep Learningによるプログラミングタスク (Program Synthesis以外)
subtitle: code completionとcode repairにDNNを使うことについての考えをdumpする
category: MachineLearning
---


Program Synthesis以外のプログラミングタスクへのDeep Learningの応用についても考えをまとめておく。


### Deep Learningの適用が考えられているプログラミングタスクの種類

[CodeXGLUEの論文](http://arxiv.org/abs/2102.04664)でベンチマークが、機械学習の分野でプログラミングを扱う際のタスクリストとして参考になりそう。CodeXGLUEの論文は以下のベンチマークを提案している。

* clone detection
* defect detection
* cloze test
* code completion
* code translation
* code search
* code repair
* text-to-code generation
* code summarization
* documentation translation

また、Related Workのsectionでは他のタスクとして"idiom mining"、"bug localization"、"test case generation"、"program synthesis"が挙げられている。この論文では別物として扱われているが、"text-to-code generation"はProgram Synthesisの一部とみなせると思う。

個人的には"cloze test"だけがこの論文で始めて知ったタスクだった。自然言語処理におけるMasked Language Modelみたいにソースコード中の1単語がmaskになっていて、そこに何が入るかを当てるタスクらしい。実タスクではなくて、おそらく特徴抽出能力の評価みたいな機械学習モデルそのものを評価するためのベンチマークに見える。

正直大半のものは試したことがなかったりで意見がない。ただ、DNNや機械学習を使うという事を考えるとプログラミング言語ごとに作りこむのは割に合わないのではないかと思っている。プログラミング言語ごとに作りこむならちゃんとプログラムの静的解析を書いたほうが良い場面が多そうなイメージがある。
だとすると、自然言語処理の応用というか流用のような形で実用的な性能になる日を待つべきなのかな、と思う。

タスク単位で気になるのはcode completionとcode repairの2つ。code completionは普段一番使うツールだし repairは以前から興味があって[DeepFix](https://aaai.org/ocs/index.php/AAAI/AAAI17/paper/view/14603)データセットを使ったテストとかもしてみたので。


### code completion

DNNをcode completionに使う上で一番気になるのは実行時間。CodeXGLUEでベースラインに使われているようなTransformerを使う場合、今のテキストエディタ・IDEで使われているような時間で候補を出すのは無理だと思う。試しに手元のPC (WSL-2) でCodeGPT2の生成を回してみると、sequence length=128で700msくらい候補生成にかかっている。
Transformerの性質として、sequence lengthの二乗の計算量がかかること、実際のソースコードは128 tokenどころではないこと、を考えると厳しそう。

実行時間を伸ばす代わりに今のコード補完よりも長いコードを補完するという手もある。CodeXGLUEではcode completionのタスクとしてtoken-level, line-levelの2種類あるが、line-levelの方がこれに当たる。
この方針のほうがDNNを使ったコード補完としては筋がいいように思う。IDEにある他のツールと動作間隔が違うので (エディタ上で動くツールで~1secくらいでどんどん表示が更新されていく印象がある) ユーザーが慣れるまで時間かかりそうではあるけれど。


### code repair

code repairの方は、説明可能性は不要なのかというのが気になっている。今の手法を見ると大体seq2seq taskと捉えていて、「正しい修正後のコードを出すこと」を目的としている。

何の情報もなしに「こう変更したらエラーが直る」と言われるだけのツールで困ることはないのかな。プログラマであれば修正内容を見たらエラー原因が分かるから問題ない？ そんなパッと見てわかるようなエラーの修正ならルールベースに書くだけでできそうな気もするけど、そういった作りこみをしないで済むことがDNN/機械学習のメリットということなんだろうか。
