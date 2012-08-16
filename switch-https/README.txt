*******************************************************
* switch-https - HTTP を HTTPS に切り替えるスクリプト *
*******************************************************

# 問題の背景
 * Apache で LDAP を認証バックエンドにしたいページがある。
 * しかし mod_authnz_ldap は Digest 認証が使えない（Basic のみ）。ので、SSL 経由でのアクセスを強制したい。
 * そう思って Require directive と mod_rewrite によるリダイレクトを共存させようとするが、うまくいかない。
    -> Require が満たされないと RewriteRule は発動しないため。
 * これは、とても困る。

# 提案する手法
 1. 対象のディレクトリに対し htaccess_sample.txt に示すような .htaccess ファイルを設置しておく。
    もしくは、httpd.conf に httpd_conf_sample.txt に示すような設定を行う。(*1)
 2. ブラウザが http://ホスト/認証対象のディレクトリ/ にアクセスする。
 3. SSLRequireSSL directive によって、非 SSL アクセス時に 403 Forbidden エラーが発生する。
 4. ErrorDocument directive で 403 エラーを補足し、switch-https に引き渡す。
 5. switch-https は、そのエラーの生じた URL が非 SSL であれば、その URL のスキームを https:// に直し、ブラウザにリダイレクトを発行する。
 6. ブラウザが https://ホスト/認証対象のディレクトリ/ にアクセスする。
 7. 今度は SSLRequireSSL directive がエラーを生じさせないので、Require によって認証が走る。

# 前提となる条件
 * 同じ FQDN を持つ http:// と https:// の VirtualHost で、同じ DocumentRoot が設定されていること。
 * CGI が動作可能であること（この例では Perl ですが Python でも C でも直ぐに移植できるでしょう）。

# 本手法の制約
 * この設定を行ったディレクトリ以下では、通常の ErrorDocument 403 が使用できなくなる。(*2)
    -> “普通の”403 エラーは、switch-https によって / にリダイレクトされる。
 * switch-https は DocumentRoot 以下であればどこに設置してもよい。
    -> ただし、Require directive の設定されていない（認証の不要な）領域に置く必要がある。
    -> メンテナンス性の観点から DocumentRoot 直下に設置することをお勧めする。
 * なお、拡張子のないスクリプトを CGI として実行させるには、.htaccess へ次のように記述すればよい。
    <Files switch-https>
       SetHandler      cgi-script
    </Files>

# 今後の課題
 * CGI じゃなくて mod_rewrite でやれればいいな（RewriteRule で %{REDIRECT_URL} が使えないという問題がある）
 * Apache のパッチを書いて投げてみる。
 * こういうシチュエーションで便利なモジュールを作る。
 * むしろ LDAP 認証モジュールを Digest 対応にする。

# 脚注
 (*1) Satisfy Any を利用して Order, Allow, Deny によるホストベースのアクセス制限と
      Require によるアクセス制限を共存しようとするシナリオでは、Order が満たされた
      時点で SSLRequireSSL を満たさなくてもアクセスが許可されてしまう。このため、
      Order が満たされる環境からアクセスされた場合、SSL へリダイレクトが行われず、
      HTTP で Require すなわち Basic 認証を行うことになってしまう。この問題は、
      .htaccess が、SSL 時と非 SSL 時で共通であるという点にあるため、httpd.conf の
      VirtualHost レベルで、SSL 時と非 SSL 時の設定をそれぞれ分割する必要がある。
 (*2) httpd.conf へ設定した場合、SSL アクセス時は問題なく ErrorDocument 403 を扱う
      ことができる（VirtualHost:443 では ErrorDocument 403 を使用しないため）。
      ただし、.htaccess を用いてディレクトリ単位の ErrorDocument 403 を記述すること
      は不可。なぜなら、非 SSL アクセス時は ErrorDocument 403 /switch-https による
      リダイレクトが必要なので、それをオーバーライドしてしまうと HTTPS に遷移する
      ことができなくなってしまうため。
