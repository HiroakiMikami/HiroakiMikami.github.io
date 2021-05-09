---
layout: post
title: Neural Programming by Exampleのデータセットについて思うこと
---

(DNNを用いた) Programming by Exampleについて、この1カ月くらいで考えていたことをまとめる。

ずっとDNNの手法の方を調査したり実験したりしてきたが、このGWで色々行き詰ってきてデータセットのことを考えたほうが良いのではないかと思いつつある。


### Programming by Exampleのデータセットの種類

DNNによるProgramming by Exampleには今のところデファクトのデータセットは今のところ存在しない。[DeepCoder](https://openreview.net/forum?id=ByldLrqlx)で使用された整数リストに対するDSL、[Karel](https://msr-redmond.github.io/karel-dataset/)(特定の状態を実現するようロボットを移動させる)、[RobustFill](https://arxiv.org/abs/1703.07469)で使われた文字列変換のデータセット、あたりを用いる論文が多い印象がある。また、3D形状をプログラムであらわす (CSGみたいな) タスクの場合はShapeNetなどの3Dモデルのデータセットが用いられている。

RobustFill, ShapeNetを除いて、ランダムに生成したプログラムとI/O exampleでデータセットを構成している。データセットをランダム生成できるのはProgramming by Exampleの大きな利点と言える。データセットのランダム生成というと多くの場合ground truthのannotationがネックになるが、Programming by Exampleの場合は処理系があれば比較的簡単にannotationを追加できる。


### ランダム生成データセットの問題

この手のランダム生成データセットのsampleを見るとIn/Out exampleとground truthのプログラムがパッと自分には結びつかないサンプルが多かった。人間がsampleを作る場合、「これをヒントに`while`を使うことを推測できるはず」みたいな解くときの論理を考えながらI/O Exampleを作ることになると思うが、コンピュータでランダムに生成する場合はそういった論理なしにexampleを作るのでまとまりのないI/O exampleによるデータセットとなっている。

結果として、ランダム生成データセットによるPbEは、プログラミングというよりも実行Traceをうまくまとめていくパズルタスクといった方が近いように思える。

あるいは、そもそもDeepCoderやKarelで扱っているようなプログラムは、そもそもspecificationをIn/Outのexampleだけで与えるのが無理なのではないか、とも感じている。例えば、`in=[1, 3, -5], [-2, 4, 1], out=5`, `in=[9, -3, 2], [3, -6, 3], out=51`という2つのexampleだけからこれが「2つのリストをうけとってその内積を出力する」プログラムを求めていることを認識するのは難しいというか無理じゃないかと思う。「2つのリストの内積を計算せよ」という自然言語でのspecificationのほうが人間にとっては遥かに有用な情報となる。

同様にExample以外のspecificationを入力とし含むか、あるいはDSLを丁寧に設計してIn/Out exampleだけでspecificationを与えられるようにするか、したデータセットを作らないと、一定以上に複雑なProgramming by Exampleは現実的にはならないかもしれないと思っている。ただ、どちらにせよデータセットの作成にかなりの手間がかかるので、もともとのProgramming by Exampleのメリットが消えてしまうのが難点となる。
