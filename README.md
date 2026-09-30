# tools

ブラウザだけで動く、ちょっとしたHTMLツールの置き場です。ツールごとにサブディレクトリを作り、`index.html`単体で完結させます。

```
tools/
├─ index.html        ← ツール一覧ページ
├─ zoom-pip/          ← ズームPiPメーカー
│   ├─ index.html
│   └─ README.md
├─ pdf-split-merge/   ← PDF分割・結合ツール
│   ├─ index.html
│   └─ README.md
└─ <次のツール>/
    ├─ index.html
    └─ README.md
```

## 運用ルール

- 各ツールは他のツールに依存せず、`index.html`を開くだけで動く単体のページにする
- サーバー処理が必要な機能は原則使わない(データはブラウザ内で完結させる)
- 新しいツールを追加したら、ルートの`index.html`にも一覧項目を追加する
- 各ツールフォルダには簡単な`README.md`(何をするツールか・使い方)を添える

## 公開

GitHub Pagesで公開する想定(`main`ブランチのルートを配信)。

## ツール一覧

| ツール | 内容 |
|---|---|
| [zoom-pip](zoom-pip/) | 動画の一部を枠で囲み、拡大映像をピクチャインピクチャで重ねて書き出すツール |
| [pdf-split-merge](pdf-split-merge/) | PDFをページ単位に分解して並べ替え、PDF/PNG/JPGとして書き出すツール |
