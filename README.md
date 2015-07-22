# sl
Supplied layers from layers*.txt, for Ruby

# Usage

## レイヤ名の一覧
```
$ ruby sl.rb --name
標準地図
淡色地図
...
提供実験::地図情報（注記）
```

## 地理院タイル目録の作成状況の一覧
```
$ ruby sl.rb --mokuroku-info
○,std,2015-07-12 09:23:10,1.21 GB,標準地図
○,pale,2015-07-14 12:13:23,1.21 GB,淡色地図
...
☓,experimental_anno,-,-,提供実験/地図情報（注記）
```

## 地理院タイル目録のURLの一覧
```
$ ruby sl.rb --mokuroku-urls
http://cyberjapandata.gsi.go.jp/xyz/std/mokuroku.csv.gz
http://cyberjapandata.gsi.go.jp/xyz/pale/mokuroku.csv.gz
...
http://cyberjapandata.gsi.go.jp/xyz/experimental_anno/mokuroku.csv.gz
```

## タイルレイヤの minZoom の確認
```
$ ruby sl.rb --min_zoom
http://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png
http://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png
http://cyberjapandata.gsi.go.jp/xyz/blank/{z}/{x}/{y}.png
http://cyberjapandata.gsi.go.jp/xyz/english/{z}/{x}/{y}.png
http://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg
2 http://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg
10 http://cyberjapandata.gsi.go.jp/xyz/gazo4/{z}/{x}/{y}.jpg
...
15 http://cyberjapandata.gsi.go.jp/xyz/experimental_anno/{z}/{x}/{y}.geojson
```
