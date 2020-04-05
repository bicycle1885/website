+++
title = "ブログ記事にSVGで図を描く"
date = 2020-04-04
[taxonomies]
tags = ["javascript", "svg", "meta"]
+++

この記事では[SVG.js](https://svgjs.com/docs/3.0/)を使って記事にSVGの図を挿入するテストをしながら、その方法を紹介します。
いい方法が見つかれば、随時更新していくつもりです。

<!-- more -->

## SVG.jsを使ったSVGの生成 {#generate-svg}

[SVG（scalable vector graphics）](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics)とは、XML形式のテキストで図を描画する技術です。
現在のブラウザはHTMLに埋め込まれたSVGの描画をサポートしているので、ブログ記事などにもSVGで簡単に図を埋め込めます。
例えば、次のような長方形（`rect`要素）と円（`circle`要素）を持つ`svg`要素をHTMLに埋め込むと、その下のような図が表示されます。
わかりやすくするため`svg`要素の境界線を表示しています。

```xml
<svg style='width: 400px; height: 200px; border: 1px solid gray;'>
    <rect fill='steelblue' x='70' y='50' width='80' height='80'/>
    <circle fill='tomato' cx='250' cy='120' r='30'/>
</svg>
```
<svg style='width: 400px; height: 200px; border: 1px solid gray;'>
    <rect fill='steelblue' x='70' y='50' width='80' height='80'/>
    <circle fill='tomato' cx='250' cy='120' r='30'/>
</svg>

しかしSVGをすべて手で書くのはあまりに面倒くさいので、プログラムでなんとか生成したくなります。
幸いなことに、JavaScriptを使えばブラウザでSVGを生成するのはそれほど難しくありません。
標準ライブラリしか使わない純粋なJavaScriptを使ってもこれは可能ですが、[SVG.js](https://svgjs.com/docs/3.0/)というSVGの生成に特化したライブラリを使えばもっと手軽になります。
もちろん、著名な[D3.js](https://d3js.org/)の方が機能が豊富で様々な可視化ができますが、SVGで簡単な図を書くには少しオーバーキルなように思います。

SVG.jsの導入は簡単です。
次のタグをHTMLの初めに記述するだけです。
実際の使用例は[この記事のMarkdownファイル](https://raw.githubusercontent.com/bicycle1885/website/master/content/blog/2020/blog-svg-test/index.md)を参考にしてください。

```html
<script src="https://cdn.jsdelivr.net/npm/@svgdotjs/svg.js@3.0/dist/svg.min.js"></script>
```
<script src="https://cdn.jsdelivr.net/npm/@svgdotjs/svg.js@3.0/dist/svg.min.js"></script>

まずはヘルパー関数として、次のような`drawSVG`関数を定義しておきます。
これはMarkdownに記述した`<script>`タグの直後にSVGの図形を埋め込んでくれます。
さらに、描画した図形のbounding boxに合わせてSVGの`viewBox`属性を設定します。
`viewBox`属性を±5ほど広げているのは、図形のストロークがbounding boxに収まらないからです。
```js
// Draw an SVG element after the script tag.
function drawSVG(svg, viewBox = "fitbbox") {
    document.currentScript.insertAdjacentElement('afterend', svg);
    let box = {};
    if (viewBox === "fitbbox") {
        let bbox = svg.getBBox();  // get bounding box
        box.x = bbox.x - 5;
        box.y = bbox.y - 5;
        box.width = bbox.width + 10;
        box.height = bbox.height + 10;
    }
    else {
        box.x = typeof viewBox.x === "undefined" ? 0 : viewBox.x;
        box.y = typeof viewBox.y === "undefined" ? 0 : viewBox.y;
        box.width = viewBox.width;
        box.height = viewBox.height;
    }
    svg.setAttribute('viewBox', `${box.x} ${box.y} ${box.width} ${box.height}`);
}
```
<script>
// Draw an SVG element after the script tag.
function drawSVG(svg, viewBox = "fitbbox") {
    document.currentScript.insertAdjacentElement('afterend', svg);
    let box = {};
    if (viewBox === "fitbbox") {
        let bbox = svg.getBBox();  // get bounding box
        box.x = bbox.x - 5;
        box.y = bbox.y - 5;
        box.width = bbox.width + 10;
        box.height = bbox.height + 10;
    }
    else {
        box.x = typeof viewBox.x === "undefined" ? 0 : viewBox.x;
        box.y = typeof viewBox.y === "undefined" ? 0 : viewBox.y;
        box.width = viewBox.width;
        box.height = viewBox.height;
    }
    svg.setAttribute('viewBox', `${box.x} ${box.y} ${box.width} ${box.height}`);
}
</script>

SVG.jsとこのヘルパー関数を使えば、例えば次のような正弦波に乗った多数の円は数行で簡単に描けます。

```js
let draw = SVG();
for (let i = 0; i < 30; ++i) {
    draw.circle(10).fill('steelblue').center(20 * i, 30 * Math.sin(i * 0.5));
}
drawSVG(draw.node);
```
<script>{
let draw = SVG();
for (let i = 0; i < 30; ++i) {
    draw.circle(10).fill('steelblue').center(20 * i, 30 * Math.sin(i * 0.5));
}
drawSVG(draw.node);
}</script>

特定の図形を繰り返し描くには、`defs`関数がおすすめです。
これはSVGの中に図形を定義し、`use`関数で描画できるようにします。

```js
// Function to define a polygon
function polygon(draw, n) {
    let radius = 5;
    let anchors = [];
    for (let i = 0; i < n; ++i) {
        let angle = 2 * Math.PI * i / n;
        anchors.push(Math.cos(angle) * radius);
        anchors.push(Math.sin(angle) * radius);
    }
    return draw.defs()
        .polygon(anchors)
        .fill('none')
        .stroke({ color: 'steelblue', width: 2 });
}

// Define polygons
let draw = SVG();
let polygons = [3, 4, 5, 6, 7].map(n => polygon(draw, n));

// Draw polygons on sine curves
for (let i = 0; i < 30; ++i) {
    let x = 20 * i;
    let y = 30 * Math.sin(i * 0.5);
    for (let j = 0; j < polygons.length; ++j) {
        draw.use(polygons[j]).center(x, y + 50 * j);
    }
}

drawSVG(draw.node);
```
<script>{
// Function to define a polygon
function polygon(draw, n) {
    let radius = 5;
    let anchors = [];
    for (let i = 0; i < n; ++i) {
        let angle = 2 * Math.PI * i / n;
        anchors.push(Math.cos(angle) * radius);
        anchors.push(Math.sin(angle) * radius);
    }
    return draw.defs()
        .polygon(anchors)
        .fill('none')
        .stroke({ color: 'steelblue', width: 2 });
}

// Define polygons
let draw = SVG();
let polygons = [3, 4, 5, 6, 7].map(n => polygon(draw, n));

// Draw polygons on sine curves
for (let i = 0; i < 30; ++i) {
    let x = 20 * i;
    let y = 30 * Math.sin(i * 0.5);
    for (let j = 0; j < polygons.length; ++j) {
        draw.use(polygons[j]).center(x, y + 50 * j);
    }
}

drawSVG(draw.node);
}</script>


## アニメーション {#svg-animation}

SVG.jsではアニメーションも簡単に作成できます。
次のように`Timeline`オブジェクトを作ってそこにアニメーションを登録すると、複数のオブジェクトのアニメーションを同期できます。
`timeline.persist(true)`と呼び出してアニメーションのrunnerをずっと保持するようにしないと、次のようなループ再生ができないので注意してください。

```js
// Define a timeline for animation
let timeline = new SVG.Timeline();
timeline.persist(true);
setInterval(function() {
    // replay
    timeline.time(0);
    timeline.play();
}, 3000);

// Define two circles
let draw = SVG();
let circle1 = draw.circle(10).center(200, 75).fill('steelblue');
let circle2 = draw.circle(10).center(200, 75).fill('tomato');

// Define synchronized animation
circle1.timeline(timeline)
    .animate(2000, 100, 'start').dmove(-100, 0)
    .animate(500).size(100)
    .animate(500).dmove(-200, 0);
circle2.timeline(timeline)
    .animate(2000, 100, 'start').dmove(+100, 0)
    .animate(500).size(100)
    .animate(500).dmove(+200, 0);

drawSVG(draw.node, { width: 400, height: 150 });
```
<script>{
// Define a timeline for animation
let timeline = new SVG.Timeline();
timeline.persist(true);
setInterval(function() {
    // replay
    timeline.time(0);
    timeline.play();
}, 3000);

// Define two circles
let draw = SVG();
let circle1 = draw.circle(10).center(200, 75).fill('steelblue');
let circle2 = draw.circle(10).center(200, 75).fill('tomato');

// Define synchronized animation
circle1.timeline(timeline)
    .animate(2000, 100, 'start').dmove(-100, 0)
    .animate(500).size(100)
    .animate(500).dmove(-200, 0);
circle2.timeline(timeline)
    .animate(2000, 100, 'start').dmove(+100, 0)
    .animate(500).size(100)
    .animate(500).dmove(+200, 0);

drawSVG(draw.node, { width: 400, height: 150 });
}</script>

もっと多くのオブジェクトでも同期して動かせます。
次の例は、41×41個の円のサイズを異なる周期で増減させています。
これくらいの数のオブジェクトなら、手元のブラウザでも遅延なく描画されているのではないでしょうか。
最初から再生するにはブラウザをリロードしてください。

```js
let draw = SVG();
let r = 5;
let nrows = 41;
let ncols = 41;
let center = { x: r * ncols , y: r * nrows };
let timeline = new SVG.Timeline();
for (let i = 0; i < nrows; ++i) {
    for (let j = 0; j < ncols; ++j) {
        let x = j * r * 2 + r;
        let y = i * r * 2 + r;
        let duration = (Math.abs(x - center.x) + Math.abs(y - center.y)) * 10 + 500;
        draw.circle(r).fill('steelblue')
            .center(x, y)
            .timeline(timeline)
            .animate({ duration: duration, when: 'start', swing: true })
            .size(r * 2)
            .loop(true, true);
    }
}
drawSVG(draw.node, { width: ncols * r * 2, height: nrows * r * 2 });
```
<script>{
let draw = SVG();
let r = 5;
let nrows = 41;
let ncols = 41;
let center = { x: r * ncols , y: r * nrows };
let timeline = new SVG.Timeline();
for (let i = 0; i < nrows; ++i) {
    for (let j = 0; j < ncols; ++j) {
        let x = j * r * 2 + r;
        let y = i * r * 2 + r;
        let duration = (Math.abs(x - center.x) + Math.abs(y - center.y)) * 10 + 500;
        draw.circle(r).fill('steelblue')
            .center(x, y)
            .timeline(timeline)
            .animate({ duration: duration, when: 'start', swing: true })
            .size(r * 2)
            .loop(true, true);
    }
}
drawSVG(draw.node, { width: ncols * r * 2, height: nrows * r * 2 });
}</script>
