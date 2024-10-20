# Marmot GitLab VM上で GitLabを構築するAnsibleプレイブック

## 概要

これはLinuxの QEMU/KVM または Vagrant でGitLabサーバーを構成するAnsibleコードです。


## Vagrantでの使い方

起動

~~~
$ vagrant up
~~~

削除

~~~
$ vagrant destroy
~~~



## QEMU/KVMの起動方法

起動

~~~
$ vm-create -f Qemukvm.yaml
~~~

削除

~~~
$ vm-destroy -f Qemukvm.yaml
~~~


## ウェブUI

1 ブラウザで https://gitlab.labo.local/ をアクセスして、

2 初期パスワードを設定して、root でログインする。

3 スパナの形をしたアイコン(Admin Area) をクリック
4 左のメニューのUsersをクリック
5 右端グリーンの[ New user ]アイコンをクリック
6 ユーザー名など登録、仮パスワードをセット
7 rootをSign out
8 追加したユーザー名でログイン、本パスワードをセット
9 右端のユーザー Settingsをクリック
10 SSH keys をクリック
11 Key のフィールドに、id_rsa.pubの内容をペースト [Add key]をクリック


## rootパスワードのリセット方法

仮想マシンにログインして、GitLabコンテナに対話型シェルを動かして
パスワードリセットコマンドを実行する。

~~~
tkr@hmc:~/marmot-gitlab$ ssh ubuntu@172.16.0.222
docker exec -it gitlab_web_1 bash
root@gitlab:/# gitlab-rake "gitlab:password:reset"
Enter username: root   
Enter password: 
Confirm password: 
Password successfully updated for user with username root.
~~~


## ユーザーの追加方法

1 ハンバーガーメニューのMenu -> Admin　へ進む
2 New user をクリック 権限はadminでユーザーを作成、仮パスワードを設定
3 登録したユーザーで再度ログインして、パスワードをセット
3 sshkey pubを登録する


## プロジェクトを登録

ファイル一個だけのProject test1を作成する

1 ログイン直後の画面にある「New Project」をクリック
  または ハンバーガーメニュー Menu -> Projects -> Create new project へ
2 Create blank project を選択
3 Project name を適当にインプットして 「Create project」をクリック




## GitHubからのプロジェクトのインポート

1 ログイン直後の画面にある「New Project」をクリック
  または ハンバーガーメニュー Menu -> Projects -> Create new project へ
2 Import project -> Repo by URL を選択
3 Git repository URL に GitHub リポジトリのURLをセットする。
  警告を消すために .gitを追加する。
4 Create project をクリックすると、GitHubからインポートされる。








## ユーザーの端末からgit clone

git clone https://gitlab.labo.local/tkr/test1
cd test1

修正して、コミット、プッシュする方法は、GitHubと同じ



## GitLab データのバックアップ

バックアップを作成すると、/var/opt/gitlab/backups 以下に、tarファイルが作成される。ファイル名にバージョンが含まれるので、リストアの参考にする。バックアップコマンドで取得されなセンシティブデータは、マニュアルでバックアップする。

~~~
# gitlab-backup create
# cp /etc/gitlab/gitlab-secrets.json /var/opt/gitlab/backups/
# cp /etc/gitlab/gitlab.rb /var/opt/gitlab/backups/
# gitlab-rake gitlab:env:info
~~~

参考: https://docs.gitlab.com/ee/raketasks/backup_gitlab.html



## GitLab データのリストア

リストアは、事前に一部のインスタンスを停止して、バックアップディレクトリのデータを指定して開始する。

~~~
# cp 1679735120_2023_03_25_15.10.0_gitlab_backup.tar /var/opt/gitlab/backups/
# gitlab-ctl stop puma
# gitlab-ctl stop sidekiq
# gitlab-ctl status
# gitlab-backup restore BACKUP=1679735120_2023_03_25_15.10.0
~~~

バックアップで取得されないセンシティブデータをコピーする。

~~~
# gitlab-secrets.json gitlab-secrets.json.org
# cp /nfs/gitlab/gitlab-secrets.json .
~~~

再構成を実行して、再起動後、チェックを実行する

~~~
# gitlab-ctl reconfigure
# gitlab-ctl restart
# gitlab-rake gitlab:check SANITIZE=true
# gitlab-rake gitlab:doctor:secrets
# gitlab-rake gitlab:artifacts:check
# gitlab-rake gitlab:lfs:check
# gitlab-rake gitlab:uploads:check
~~~

こちらも戻しておく

~~~
# mv gitlab.rb gitlab.rb.org
# cp /nfs/gitlab/gitlab.rb .
~~~

参考: https://docs.gitlab.com/ee/raketasks/restore_gitlab.html



## GitLabバージョンアップ

移行では、移行元と移行先のGitLabのバージョンが一致していなければならない。そのため、移行元のバージョンを上げ、移行先と一致させる手順をとる。その際、アップグレードパスに沿って、バージョンを上げなければならない。そして、バージョンが一致した処で、バックアップを取得する。

~~~
# apt-cache madison gitlab-ce
# apt install gitlab-ee=15.0.5-ce.0
~~~

参考:
* https://docs.gitlab.com/ee/update/package/index.html#upgrade-to-a-specific-version-using-the-official-repositories
* https://docs.gitlab.com/ee/update/index.html#upgrade-paths 

