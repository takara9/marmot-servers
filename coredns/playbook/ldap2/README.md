# LDAPサーバーのセットアップ方法


## 初期情報のリスト表示

~~~
ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
~~~


## 登録

パスワードの固定入力で登録

~~~
ldapadd -x -w secret -D "cn=Manager,dc=labo,dc=local" -f org.ldif
ldapadd -x -w secret -D "cn=Manager,dc=labo,dc=local" -f org-unit.ldif
ldapadd -x -w secret -D "cn=Manager,dc=labo,dc=local" -f user1.ldif 
ldapadd -x -w secret -D "cn=Manager,dc=labo,dc=local" -f user2.ldif
ldapadd -x -w secret -D "cn=Manager,dc=labo,dc=local" -f user3.ldif  
~~~

対話型パスワードの入力

~~~
ldapadd -x -D "cn=Manager,dc=labo,dc=local" -W -f org.ldif
~~~


## ローカル環境からの登録結果確認

~~~
ldapsearch -x -b 'dc=labo,dc=local' '(objectclass=*)'
ldapsearch -x -H ldaps://ldab.labo.local  -b 'dc=labo,dc=local' '(objectclass=*)'
~~~

## リモート環境からの確認

~~~
ldapsearch -x -h ldap.labo.local -w secret -D "cn=manager,dc=labo,dc=local" -b 'dc=labo,dc=local' '(objectclass=*)'
~~~


## 参考資料
* [slapd-config(5) — Linux manual page](https://man7.org/linux/man-pages/man5/slapd-config.5.html)
* [OpenLDAP Software 2.4 Administrator's Guide](https://www.openldap.org/doc/admin24/index.html)
* [5. Configuring slapd](https://www.openldap.org/doc/admin24/slapdconf2.html#Configuration%20Example)
* [@IT OpenLDAPで始めるディレクトリサーバ構築（1）](https://www.atmarkit.co.jp/ait/articles/0807/17/news132.html)


