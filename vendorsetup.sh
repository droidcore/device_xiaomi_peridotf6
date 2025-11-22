#!/bin/bash

# Vendor (fresh clone)
echo "Cloning vendor tree..."
rm -rf vendor/xiaomi/peridot
git clone https://github.com/droidcore/vendor_xiaomi_peridots.git vendor/xiaomi/peridot

# Kernel source (fresh clone)
echo "Cloning kernel source tree..."
rm -rf kernel/xiaomi/sm8635
git clone -b lineage-23.0 --depth 1 https://github.com/droidcore/android_kernel_xiaomi_sm8635.git kernel/xiaomi/sm8635
rm -rf kernel/xiaomi/sm8635-modules
git clone -b lineage-23.0 --depth 1 https://github.com/droidcore/android_kernel_xiaomi_sm8635-modules.git kernel/xiaomi/sm8635-modules

rm -rf kernel/xiaomi/sm8635-devicetrees
git clone -b lineage-23.0 --depth 1 https://github.com/peridot-dev/android_kernel_xiaomi_sm8635-devicetrees.git kernel/xiaomi/sm8635-devicetrees

# Hardware xiaomi (fresh clone)
echo "Cloning hardware xiaomi source..."
rm -rf hardware/xiaomi
git clone -b lineage-23.0 https://github.com/PeridotSupremacy/hardware_xiaomi.git hardware/xiaomi

# MiuiCamera device tree (fresh clone)
echo "Cloning MiuiCamera device tree..."
rm -rf device/xiaomi/peridot-miuicamera
git clone https://github.com/F6-test/device_xiaomi_peridot-miuicamera.git device/xiaomi/peridot-miuicamera

# MiuiCamera vendor tree (fresh clone)
echo "Cloning MiuiCamera vendor tree..."
rm -rf vendor/xiaomi/peridot-miuicamera
git clone https://github.com/F6-test/vendor-xiaomi-peridot-miuicamera.git vendor/xiaomi/peridot-miuicamera

# Viper4Android 
echo "Cloning Viper4Android tree..."
rm -rf packages/apps/ViPER4AndroidFX
git clone https://github.com/TogoFire/packages_apps_ViPER4AndroidFX.git packages/apps/ViPER4AndroidFX

# Gamebar
echo "Cloning Gamebar tree..."
rm -rf packages/apps/GameBar
git clone https://github.com/droidcore/packages_apps_GameBar.git packages/apps/GameBar

# diag (cherry pick)
echo "Fetching QPR1 compat..."
cd device/xiaomi/peridot
git fetch https://github.com/GuidixX/device_xiaomi_peridot 16
git cherry-pick 4f78def327d817d4c3a9e99ed439dcff64183365
cd ../../../

# Compat (cherry pick)
echo "Fetching QPR1 compat..."
cd hardware/lineage/compat
git fetch https://github.com/stx-staging/android_hardware_statix_compat bp3a
git reset --hard FETCH_HEAD

# Picking sepolicy for QPR1 (cherry pick)
echo "Picking sepolicy fix..."
cd ../../..
cd device/qcom/sepolicy_vndr/sm8650
git fetch https://github.com/sm8635-dev/device_qcom_sepolicy_vndr
git cherry-pick 39cfd17977cc664fa8393b6569c39179f4127b2d 1d2c884133bb23d780fc35ecff27d2e6eeabe314 8e148a4417233704f40c223c0624d41f017b490e

# Always back to root at the end
if command -v croot &>/dev/null; then
  croot
else
  cd "$ANDROID_BUILD_TOP" || true
fi

echo "vendorsetup.sh execution complete."
