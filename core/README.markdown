# Ter

Ter のモデルになります。

## Base

```
      User --------- :have [1:1] ---------> Cofig

Schema --------- :have [1:n] ---------> Camera
```

## 普通のER図 のデータ構造

![普通のER図のデータ構造](https://bitbucket.org/yanqirenshi/ter/raw/ed48c00a7c87b7781f34f3b7280efc67cc61e4f9/web/assets/ss-20180518-144005.png "普通のER図のデータ構造")

## T字形ER図 のデータ構造

![T字形ER図 のデータ構造](https://bitbucket.org/yanqirenshi/ter/raw/ed48c00a7c87b7781f34f3b7280efc67cc61e4f9/web/assets/ss-20180518-145815.png "T字形ER図 のデータ構造")

## Usage

```lisp
(ter.db:start)
```

### schema.rb

```
(in-package :ter)
(import-schema.rb (get-schema-graph (get-schema *graph* :code :your-schema-code))
                  "/your/schema.rb/path/schema.rb")
```

## Installation

```lisp
(ql:quickload :ter)
```
