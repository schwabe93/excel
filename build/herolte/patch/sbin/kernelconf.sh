#!/system/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Busybox
if [ -e /su/xbin/busybox ]; then
  BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
  BB=/sbin/busybox;
else
  BB=/system/xbin/busybox;
fi;
fi;

# Mount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,rw /;

# MTweaks: Make internal storage directory
MTWEAKS_PATH=/data/.mtweaks
if [ ! -d $MTWEAKS_PATH ]; then
  $BB mkdir $MTWEAKS_PATH;
fi;
$BB chmod 0777 $MTWEAKS_PATH;
$BB chown 0.0 $MTWEAKS_PATH;

# MTweaks: Delete backup directory
$BB rm -rf $MTWEAKS_PATH/bk;

# MTweaks: Make backup directory.
$BB mkdir $MTWEAKS_PATH/bk;
$BB chmod 0777 $MTWEAKS_PATH/bk;
$BB chown 0.0 $MTWEAKS_PATH/bk;

# MTweaks: Save original voltages
$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster1_volt_table > $MTWEAKS_PATH/bk/cpuCl1_stock_voltage
$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster0_volt_table > $MTWEAKS_PATH/bk/cpuCl0_stock_voltage
$BB cat /sys/devices/14ac0000.mali/volt_table > $MTWEAKS_PATH/bk/gpu_stock_voltage
$BB chmod -R 755 $MTWEAKS_PATH/bk/*;

# Deep Sleep fix by @Chainfire (from SuperSU)
for i in `ls /sys/class/scsi_disk/`; do
cat /sys/class/scsi_disk/$i/write_protect 2>/dev/null | grep 1 >/dev/null
if [ $? -eq 0 ]; then
echo 'temporary none' > /sys/class/scsi_disk/$i/cache_type
fi
done

# PWMFix
# 0 = Disabled, 1 = Enabled
$BB echo "0" > /sys/class/lcd/panel/smart_on

# SELinux Permissive / Enforcing Patch
# 0 = Permissive, 1 = Enforcing
$BB chmod 777 /sys/fs/selinux/enforce
$BB echo "0" > /sys/fs/selinux/enforce
$BB chmod 640 /sys/fs/selinux/enforce

# Stock CPU / GPU Settings
$BB echo "2288000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
$BB echo "208000" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
$BB echo "1586000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
$BB echo "130000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
$BB echo "650" > /sys/devices/14ac0000.mali/max_clock
$BB echo "260" > /sys/devices/14ac0000.mali/min_clock
$BB echo "blu_active" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
$BB echo "blu_active" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Tweaks: SD-Card Readhead (@Morogoku)
$BB echo "2048" > /sys/devices/virtual/bdi/179:0/read_ahead_kb;

# Tweaks: Internet Speed (@Morogoku)
$BB echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
$BB echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
$BB echo "1" > /proc/sys/net/ipv4/tcp_sack;
$BB echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
$BB echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
$BB echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes;
$BB echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl;
$BB echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout;
$BB echo "404480" > /proc/sys/net/core/wmem_max;
$BB echo "404480" > /proc/sys/net/core/rmem_max;
$BB echo "256960" > /proc/sys/net/core/rmem_default;
$BB echo "256960" > /proc/sys/net/core/wmem_default;
$BB echo "4096,16384,404480" > /proc/sys/net/ipv4/tcp_wmem;
$BB echo "4096,87380,404480" > /proc/sys/net/ipv4/tcp_rmem;

# Spectrum Profile

# Customisations


# Unmount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,ro /;
