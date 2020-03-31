+++
title = "「1から始めるJuliaプログラミング」が出版されました"
date = 2020-03-29
hoge = "HOGE"
[taxonomies]
tags = ["julia", "book"]
+++

先日，私達が執筆した[「1から始めるJuliaプログラミング」](https://www.coronasha.co.jp/np/isbn/9784339029055/)がコロナ社から出版されました。
本書はJulia言語の入門者に向けた解説書です。
3月26日頃から[一般書店に置いてあったり](https://twitter.com/shosen_bt_pc/status/1242642658696114176)，[Amazonでの注文](https://www.amazon.co.jp/gp/product/433902905X)ができるようになっているようです。

<!-- more -->

## そもそもJuliaとは

そもそもJuliaがどのような言語なのかをご存じない方も多いと思うので少しだけ説明します。
Juliaは2012年に公開された科学技術計算を得意とするプログラミング言語です。
MITのJeff Bezanson氏らを中心として開発が進められ，2018年になってバージョン1.0が公開されました。
2020年3月29日現在では，Julia 1.4が最新のリリース版です。
Windows・Linux・macOS用のバイナリが[公式のダウンロードページ](https://julialang.org/downloads/)で提供されています。

私が考えるJuliaの素晴らしさは，動的な実行が可能でありながら，**実行速度を一切妥協しない**ところです。
多くの動的実行可能なプログラミング言語では，実行速度は無視はしないにせよ，最重要視する要素ではありません。
しかし，JuliaはPythonやRのように動的実行が可能でありながら，実行速度を最大の関心事と言えるほど重要視しています。
結果として，CやFortranなどで書かれたプログラムにも[見劣りしない実行性能](https://julialang.org/benchmarks/)を誇ります。

構文も非常に簡潔です。
例えば次のJuliaコードは，[the eight queens puzzle](https://en.wikipedia.org/wiki/Eight_queens_puzzle)として知られる問題のソルバです。
これは，N×Nのチェス盤にN個のクイーン（縦・横・斜めに自由に動ける）を互いに掛からないように何通り置けるか数える問題です。
Juliaを初見の人でも，次のコードがどう動くのか大体把握できるのではないでしょうか。
```julia
# N queens puzzle solver
function nqueens(n)
    @assert n ≥ 1
    # queens' rank (row) for each file (column)
    # rank[file] = 0 means no queen is placed at the file
    ranks = zeros(Int, n)
    return solve(ranks, 1)
end

# recursive solver
function solve(ranks, file)
    n = length(ranks)
    nsols = 0  # the number of solutions
    for rank in 1:n
        # check ranks
        if any(rank == ranks[i] for i in 1:file-1)
            continue
        end
        # check diagonals
        if any(file-i == abs(rank-ranks[i]) for i in 1:file-1)
            continue
        end
        # put queen at (rank, file)
        ranks[file] = rank
        if file == n
            # found a solution
            nsols += 1
        else
            # go to the next file
            nsols += solve(ranks, file + 1)
        end
        ranks[file] = 0
    end
    return nsols
end
```

さらに，多次元配列や線形代数のライブラリなど，科学技術計算では必要不可欠のツールが標準ライブラリとして組み込まれており，Juliaさえインストールしておけば基礎的な計算は行えるようになっています。
もちろん，必要があればサードパーティのパッケージをインストールして使えます。
Julia標準のパッケージ管理ツールは大変優秀なので，パッケージの追加や削除をストレス無く行なえます。


## 本の概要

本書の共著者である進藤さんが書いた「まえがき」の一部を引用しましょう。

> Juliaは，アメリカのマサチューセッツ工科大学（MIT）で開発された新しいプログラミング言語で，その最大の特徴は，簡潔な文法と高速な実行速度が両立している点にある。それ以外にも，Lispから影響を受けたと思われる多重ディスパッチやメタプログラミングなど，他のプログラミング言語にはあまりない魅力的な機能が満載である。「Juliaっていう名前を最近よく聞くけれど，どんなプログラミング言語なんだろう？」「PythonやMATLABとどこが違うの？」そんな声も周囲からよく聞かれるようになってきた。そこで，本書ではJuliaを初めて学ぶ人のために，Juliaの言語設計や基本的な文法について1 から説明し，Juliaについて広く知っていただくことを第一の目的としている。また，後半では，Juliaをさらに使いこなすために，主要な外部パッケージの紹介や，高速化のためのプロファイリングやコード最適化など，やや高度な内容についても解説を行っている。そのため，すでにJuliaを使用しているユーザにとっても有益な情報となることを期待している。

<a href="https://www.coronasha.co.jp/np/isbn/9784339029055/"><img src="book-cover-fs8.png" alt="書影" style="float: right; max-width: 33%; margin-left: 1rem;"></a>
まえがきにもあるとおり，本書はJuliaを初めて学ぶ人でも読めるようになっています。
少し使ったことがある程度の人でも得るものは多いでしょう。
より具体的には，次のような人を対象読者としています。

- Juliaに興味を持ち，初めて触れるプログラミング学習者
- 科学技術計算を高速かつ手軽に行いたい学生や研究者

Juliaは科学技術計算を得意とするプログラミング言語ですので，PythonやMATLABを使っている方には特に試してみることをおすすめします。
学校の課題や研究の強力な武器になることをお約束します。

本書を読む上でJuliaの知識は前提としませんが，他のプログラミング言語を使ったことがあれば習得は早いでしょう。
特に，コマンドラインの操作にある程度慣れていると，色々なトラブルが避けられると思います。

内容は次の4章に分かれています。
1. 入門 ― 言語の概要と環境のセットアップ
2. 言語機能 ― 基本的な構文やデータ型からパッケージ管理まで
3. ライブラリの使い方 ― 線形代数，入出力，他言語との連携，プロットなど
4. 高速化 ― プロファイリングのとり方と速いコードを書く上での注意点

実質200ページ弱の薄い本にこれだけ広範囲の内容を収めています。
現在までのところ，これだけ広く体系的にまとめた書籍は無いと思います。
一方で，それぞれのトピックをあまり深く掘り下げられなかった感はあるように思います。
これは今後出版される書籍の課題になるでしょう。

本文の説明は，`julia`コマンドで起動する対話的実行環境（REPL）を中心に構成されています。
つまり，日本語の説明とコードの具体例が交互に繰り返されています。
説明を読みながら，REPLを使って実際に実行結果を確かめられるようになっています。
このとき，最短経路を通ってどんどん読み進めるのではなく，コードを少し変えるとどう動きが変わるかなどの寄り道をしながら読むと，より理解が深まるでしょう。
REPLはそのような実験に最適な環境です。

本書でJuliaの基本を把握すれば，英語で書かれている[公式マニュアル](https://docs.julialang.org/en/v1/)やパッケージのマニュアルを参照するのも容易になるでしょう。
Juliaの[Discourseフォーラム](https://discourse.julialang.org/)や[Slackチャネル](https://slackinvite.julialang.org/)で質問するのも良いでしょう。
英語でのコミュニケーションに抵抗があるようでしたら，我々の主催しているJuliaTokyoの[Slackチャネル](https://join.slack.com/t/juliatokyo/shared_invite/enQtMzI3MTI1MTcyNTc4LTM3ZDcwOTMwOTE0NjJkZTgyNjU1NjJjNTAzYTI3MTIzMWUwMmI0MmEwNDU5NTcxMTZkY2UwOWZjYjhmNWY0OGU)もあります。


## 最後に

共著者の進藤裕之さんやコロナ社編集部の皆さまには出版にあたり大変お世話になりました。
雑誌の寄稿などを除けば初めての商業出版でしたので，色々と見積もりが甘かったり，自分の中で思ったようにいかなかった部分もありましたが，おかげさまで無事出版まで漕ぎ着けました。

拙著を購入してくださった方々には，深くお礼申し上げます。
もし読む価値のある本だと思われたなら，是非周りの人にも紹介してください。
そしてできることなら，ブログやTwitterなどで紹介してくださると大変ありがたいです。
本書の内容に間違いやご意見などありましたら，bicycle1885@gmail.comまでご連絡いただけると幸いです。


## 内容の補足

本書の内容について，正誤表をまとめるところがまだ無いので，この記事で速報的にお知らせしようと思います。
後にどこか別の場所に移行するかも知れませんが，そうなればここでもお伝えします。
他にも気になる記述があれば，ぜひご連絡ください。

### 初版第1刷

- *2.4.7 パラメトリック型の階層関係*

    p.52の中段のコード例で
    ```julia
    function distance(p::Point{T<:Number}) where T
        # 何らかの処理
    end
    ```
    と書いてあるが，正しくは次の通り
    ```julia
    function distance(p::Point{T}) where T <: Number
        # 何らかの処理
    end
    ```

- *2.8.8 識別子の変換規則*

    p.93の説明で使われている「ローカル変数」という言葉は，厳密にはあまり正しくない使い方である。
    マクロがfor文などのローカルスコープの外で展開されると，分類としてはグローバル変数になることもある。
    ただし，衛生的なマクロでは普通には参照できない変数名になるので，実質的にはローカル変数と考えても問題はないと思われる。

- *3.2.5 XMLファイルの入出力*

    p.129下段の本文中で「EzXML.jl」が1ヶ所「ExXML.jl」と誤記されている。
