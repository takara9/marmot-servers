# marmot-mail

## 概要

メールサーバーで、postfixのインターネットとローカルメールサーバのGWとなるロールと
デフォルトリレーホストに転送するサーバーの２種類をセットアップします。

KVM+QEMUの仮想サーバーを操作するツール https://github.com/takara9/marmot-kvm-tools を
使ってVMをセットアップして使用します。


playbook/mail-server  Postfixとdovecotを設定
playbook/mail-client  Postfixリレーのみ（テスト用）




