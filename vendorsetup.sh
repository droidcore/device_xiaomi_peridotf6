#!/bin/bash

# Vendor (fresh clone)
echo "Cloning vendor tree..."
rm -rf vendor/xiaomi/peridot
git clone -b lineage-23.0 https://codeberg.org/blu967/vendor_xiaomi_peridot.git vendor/xiaomi/peridot

# Kernel source (fresh clone)
echo "Cloning kernel source tree..."
rm -rf kernel/xiaomi/sm8635
git clone -b ksun --depth 1 https://github.com/droidcore/android_kernel_xiaomi_sm8635.git kernel/xiaomi/sm8635
rm -rf kernel/xiaomi/sm8635-modules
git clone -b lineage-23.0 --depth 1 https://github.com/droidcore/android_kernel_xiaomi_sm8635-modules.git kernel/xiaomi/sm8635-modules

rm -rf kernel/xiaomi/sm8635-devicetrees
git clone -b lineage-23.0 --depth 1 https://github.com/peridot-dev/android_kernel_xiaomi_sm8635-devicetrees.git kernel/xiaomi/sm8635-devicetrees

# Hardware xiaomi (fresh clone)
echo "Cloning hardware xiaomi source..."
rm -rf hardware/xiaomi
git clone -b lineage-23.0 https://github.com/droidcore/hardware_xiaomi.git hardware/xiaomi

# Dolby
rm -rf packages/apps/XiaomiDolby
git clone -b lineage-23.0 https://github.com/lightbulb-box/android_packages_apps_XiaomiDolby packages/apps/XiaomiDolby

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

# KProfiles (fresh clone)
echo "Cloning KProfiles..."
rm -rf packages/apps/KProfiles
git clone -b lineage-23.1 https://github.com/sm8635-dev/packages_apps_KProfiles.git packages/apps/KProfiles

# Gamebar
echo "Cloning Gamebar tree..."
rm -rf packages/apps/GameBar
git clone https://github.com/droidcore/packages_apps_GameBar.git packages/apps/GameBar

# FastCharge (fresh clone)
echo "Cloning FastCharge..."
rm -rf packages/apps/FastCharge

# Picking sepolicy for QPR1 (cherry pick)
echo "Picking sepolicy fix..."
cd device/qcom/sepolicy_vndr/sm8650
git fetch https://github.com/droidcore/device_qcom_sepolicy_vndr
git cherry-pick 8e148a4417233704f40c223c0624d41f017b490e
croot 

# Refresh signing keys
if [ -d vendor/evolution-priv/keys ]; then
  echo "Removing existing signing keys..."
  rm -rf vendor/evolution-priv/keys
fi
echo "Cloning fresh signing keys..."
git clone https://github.com/AbuRider/priv_keys.git -b evox vendor/evolution-priv/keys

# Always back to root at the end
if command -v croot &>/dev/null; then
  croot
else
  cd "$ANDROID_BUILD_TOP" || true
fi

echo "vendorsetup.sh execution complete."
