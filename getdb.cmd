@echo off
echo If this command fails, run 'adb root' to switch into root access mode.
adb pull /data/data/org.apcshackware.golfstroke/databases/strokecounts.db
