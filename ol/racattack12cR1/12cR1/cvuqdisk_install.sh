if [ -f /media/sf_12cR1/linuxamd64_12c_grid_1of2.zip ] ; then
  [ -f /u01/stage/grid/rpm/cvuqdisk-1.0.9-1.rpm ] || unzip -o /media/sf_12cR1/linuxamd64_12c_grid_1of2.zip -d /u01/stage grid/rpm/cvuqdisk-1.0.9-1.rpm
else
  echo "this script require the linuxamd64_12c zip files on 12cR1 folder"
  exit 1
fi

rpm -q cvuqdisk 2>/dev/null >/dev/null
if [ $? -eq 0 ]; then
  echo "cvuqdisk found installed, skipping.."
else
  if [ -f /u01/stage/grid/rpm/cvuqdisk-1.0.9-1.rpm ] ; then
    yum --disableplugin='*' -C --disablerepo='*' localinstall -y /u01/stage/grid/rpm/cvuqdisk-1.0.9-1.rpm
  fi
fi
