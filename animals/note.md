なんか、ビジネスドメインでのコードの責任の切り分け方は、うまい設計をうまない気がしている。
どちらかというと、データ構造とか、アルゴリズムが近いもの同士をまとめていったほうが、きれいに長生きするコード（ライブラリとしてそのうち重宝されるコード）がでてくるイメージ。

具体的には、いま自分は地球の生き物を題材にしたゲームをつくっているけど、
世界のクラスと、プレイヤーのクラスと、生き物のクラスなどにいま分けてみた。

でも、ともすると◯◯マネージャーみたいなクラス（クラスメソッドしかもたないで、引数に対して操作を実行してあげる）がいっぱい生えてくる。なんかうまくない。