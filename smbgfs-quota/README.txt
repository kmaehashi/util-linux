[このツールについて]
GFS のクォータは Samba でサポートされていないため、
「マイ コンピュータ」でネットワークドライブの残容量を表示すると
ファイルシステム全体の空き容量が表示されてしまいます。

smbgfs-quota コマンドでは、
Samba -> smbgfs-quota -> gfs_quota
のように Samba と gfs_quota 間を取り持つことで、
GFS のクォータ情報を Samba に渡します。

使用するには、smb.conf の [global] セクションで
get quota command = /path/to/smbgfs-quota
のように指定します。

また、このディレクトリ内の gfs_quota コマンドを使うことで、
GFS 以外の環境でも擬似的に smbgfs-quota のテストを行うことができます。
gfs_quota は /sbin に配置してください。

なお、Samba 3.0.x / Samba 3.2.x で動作が確認されています。

[注意]
GFS 2 では、標準の (VFS) Quota がサポートされているため、
このコマンドは不要なようです。
