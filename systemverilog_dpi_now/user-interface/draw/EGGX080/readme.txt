=====================================================
  Easy and Gratifying Graphics library for X11
  EGGX / ProCALL  version 0.80
=====================================================  

  EGGX / ProCALL は， 究極の簡単さを目指して作成した X11 グラ
フィックスライブラリです．懐かしの BASIC 風の pset, line とい
った関数で簡単にグラフィックスを楽しむことができます．

  このライブラリは，従来は PROCALL と呼んでいました．しかし，
最近の拡張によって C の関数は Pro-FORTRAN の原型をとどめてい
ない状態になったので，

 - このライブラリの C の関数群 -> EGGX
 - このライブラリの FORTRAN サブルーチン群 -> ProCALL

と呼ぶことにしました．

 「EGG」とは Xlib の機能の一部を使っている,という意味で「卵」
であり，また，プログラマの「卵」・ビギナーの「X11 で絵を描き
たい」という希望をかなえてるという意味があります．

  EGGX では，AfterStep，WindowMaker のアプレットが簡単に作成
できます． sample ディレクトリの plamoclock.c をご覧いただく
とわかりますが，デジタル時計程度のものであれば，わずか数十行
で作れてしまいます．日本製のアプレットがたくさん誕生する事を
期待しています．

  EGGX/ProCALL が多くの「卵」を育てる道具になれば幸いです．


●インストール方法は install.txt を御覧ください．


●マニュアルは eggx_procall.ps です．

  EGGX/ProCALL の Web ページ，

  http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall/

  には pdf 版のマニュアルもあります．pdf のマニュアルですと，
AcrobatReader でブックマークとサムネイルが表示できるので，大
変便利だと思います．


●関数名の convention について．

  EGGX version 0.80 以降では，EGGX の実際の関数名はすべて
eggx_ で始まる名前になっています．例えば pset() の場合は
eggx_pset() という具合です．eggx.h を include すると，すべて
の関数について #define pset eggx_pset のようにマクロが働き，
マニュアル通りに EGGX が利用できるようになっています．
  もし，eggx_ で始まる関数を直接使いたい場合は，eggxlib.h を
include してください．


●注意

　16bpp 以上の X サーバでの利用を強くお勧めします．8bpp の X
サーバでは，いくつかの関数が機能しません．Visual を複数持つ X
サーバの場合は， TrueColor Visual が使えれば，EGGX/ProCALL は
TrueColor でウィンドゥを開くようになっています(PseudoColor が
デフォルトでも OK です)．

    以下の関数，サブルーチンにおいて version 0.55 までとの
  互換性が失われています．
   - drawstr 関数 : 引数の変更
   - imgsave 関数 : saveimgに名称変更，引数の変更
   - drawarc, fillarc 関数,サブルーチン : 引数の変更
   - xcirc1 サブルーチン : 削除
   - xarc サブルーチン : 削除
  ただし，drawstr 関数, imgsave 関数では可変長引数が使える
  ため，大変便利になりました．
  drawstr 関数では，描く文字を printf と同様の引数とする事
  ができます．saveimg 関数では 保存するファイル名を printf
  と同様の引数とする事ができます．
    また version 0.70 で drawarc, fillarc 関数，サブルーチ
  ンの引数を修正しました．x方向，y方向の半径をそれぞれ指定
  できるようになりました．
    version 0.55 を使ったソースを 0.7x 用に修正するのは 簡
  単です．
   - drawstr 関数
     最後から 2 番目の文字列の引数の str  を最後の引数とし
     ます．
   - saveimg 関数
     ファイル名 fname とファイル名につける数字 n を 以下の
     のように最後の引数にします．
     saveimg( .... , "img%d.gif",i ) ;
   - drawarc, fillarc 関数,サブルーチン
     drawarc( win,x,y,rad,rad,0,360,1 ) ;
     のように，半径を 2 つ与えてください．
   - xcirc1 サブルーチン
     新設の drawcirc サブルーチンを使います．
   - xarc サブルーチン
     新設の drawarc サブルーチンを使います．

  また，以下の C 関数，FORTRANサブルーチンで名称変更があり
  ます．現在は，古い名称でも使えるようになっていますが，将
  来は古い名称での呼び出しは削除する予定です．
    - clsx 関数  → gclr に名称変更
    - clsc 関数  → tclr に名称変更
    - plot 関数  → line に名称変更
    - arohd 関数 → drawarrow に名称変更
    - imgsave サブルーチン → saveimg に名称変更

  詳細は eggx_procall.ps を御覧ください．


●連絡先

　cyamauch@a.phys.nagoya-u.ac.jp

  バグ報告，要望などお待ちしております．
