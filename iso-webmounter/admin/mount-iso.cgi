#! /bin/sh

PREFIX="/home/kenichi"

ISO_IMAGE_NAME="${QUERY_STRING}"
ISO_BASE_NAME="$(basename "${ISO_IMAGE_NAME}")"
ISO_SHARE_NAME="iso-$(echo "${ISO_IMAGE_NAME}" | md5sum | awk '{print $1}')"

ISO_IMAGE_PATH="${PREFIX}/public_html/${ISO_IMAGE_NAME}"
ISO_MOUNT_PATH="/tmp/terastation/mnt/${ISO_BASE_NAME}"

echo "Content-Type: text/html"; echo;

echo "
<html>
<head><title>Mounting...</title></head>
<body>
<a href="./">&lt;&lt; Back to the Index</a>
<h1>ISO Access</h1>
<ul>
<li><strong>Windows:</strong> \\\\${HTTP_HOST}\\${ISO_SHARE_NAME}\\</li>
<li><strong>Mac OS X:</strong> smb://${HTTP_HOST}/${ISO_SHARE_NAME}/</li>
<li><a href="?download">Download the ISO image</a></li>
</ul>

<h1>Log</h1>
<form><textarea style='width: 80%; height: 50%;'>
"

echo "# Creating mount point..."
mkdir -p "${ISO_MOUNT_PATH}" 2>&1 && echo "OK"
echo

echo "# Trying to mount as UDF..."
sudo mount -t udf -o ro,nodev,noexec,nosuid,loop "${ISO_IMAGE_PATH}" "${ISO_MOUNT_PATH}" 2>&1 && echo "OK"
echo

echo "# Trying to mount as ISO9660..."
sudo mount -t iso9660 -o ro,nodev,noexec,nosuid,loop "${ISO_IMAGE_PATH}" "${ISO_MOUNT_PATH}" 2>&1 && echo "OK"
echo

echo "# Adding Usershare..."
net usershare add "${ISO_SHARE_NAME}" "${ISO_MOUNT_PATH}" "" "" guest_ok=y 2>&1 && echo "OK"
echo

echo "# Done."

echo "
</textarea></form>

<script type='text/javascript'>
<!--
	location.href = 'file://///${HTTP_HOST}/${ISO_SHARE_NAME}/';
// -->
</script>
</body>
</html>
"

exit


