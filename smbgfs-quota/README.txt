[���̃c�[���ɂ���]
GFS �̃N�H�[�^�� Samba �ŃT�|�[�g����Ă��Ȃ����߁A
�u�}�C �R���s���[�^�v�Ńl�b�g���[�N�h���C�u�̎c�e�ʂ�\�������
�t�@�C���V�X�e���S�̂̋󂫗e�ʂ��\������Ă��܂��܂��B

smbgfs-quota �R�}���h�ł́A
Samba -> smbgfs-quota -> gfs_quota
�̂悤�� Samba �� gfs_quota �Ԃ���莝���ƂŁA
GFS �̃N�H�[�^���� Samba �ɓn���܂��B

�g�p����ɂ́Asmb.conf �� [global] �Z�N�V������
get quota command = /path/to/smbgfs-quota
�̂悤�Ɏw�肵�܂��B

�܂��A���̃f�B���N�g������ gfs_quota �R�}���h���g�����ƂŁA
GFS �ȊO�̊��ł��[���I�� smbgfs-quota �̃e�X�g���s�����Ƃ��ł��܂��B
gfs_quota �� /sbin �ɔz�u���Ă��������B

�Ȃ��ASamba 3.0.x / Samba 3.2.x �œ��삪�m�F����Ă��܂��B

[����]
GFS 2 �ł́A�W���� (VFS) Quota ���T�|�[�g����Ă��邽�߁A
���̃R�}���h�͕s�v�Ȃ悤�ł��B
