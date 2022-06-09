# メモアプリ
メモを書き留めておける簡単なWebアプリケーションです。
編集、削除もブラウザ上から行うことができます。

# How to use
## 初回のみ行う操作
1. 右上の Fork ボタンを押してください。
`#{自分のアカウント名}/sinatra-practice` が作成されます。
2. 作業PCの任意の作業ディレクトリにて git clone してください。
`$ git clone https://github.com/自分のアカウント名/sinatra-practice.git`
3. `cd sinatra-practice` でカレントディレクトリを変更してください。
4. `bundle install` を実行して環境セットアップしてください。
 Bundlerがインストールされていない場合は`bundle install`する前に`gem install bundler`を実行してBundlerをダウンロードしてください。

 ## アプリケーションを起動する際に行う操作
1. `sinatra-practice`をカレントディレクトリにした状態で`bundle exec ruby app.rb`を実行します。
2. お使いのブラウザで`http://localhost:4567/`にアクセスすると、メモアプリを使うことができます。

