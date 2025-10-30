#!/bin/bash


# Vendor (fresh clone)
echo "Cloning vendor tree..."
rm -rf vendor/xiaomi/peridot
git clone -b lineage-23.0 https://github.com/lightbulb-box/vendor_xiaomi_peridot.git vendor/xiaomi/peridot

# Kernel source (fresh clone)
echo "Cloning kernel source tree..."
rm -rf kernel/xiaomi/sm8635
git clone -b lineage-23.0 https://github.com/lightbulb-box/kernel_xiaomi_sm8635.git kernel/xiaomi/sm8635

rm -rf kernel/xiaomi/sm8635-modules
git clone -b lineage-23.0 https://github.com/lightbulb-box/kernel_xiaomi_sm8635-modules.git kernel/xiaomi/sm8635-modules

rm -rf kernel/xiaomi/sm8635-devicetrees
git clone -b lineage-23.0 https://github.com/lightbulb-box/kernel_xiaomi_sm8635-devicetrees.git kernel/xiaomi/sm8635-devicetrees

# Miuicamera
git clone https://github.com/peridot-hyperos-2/vendor-xiaomi-peridot-miuicamera vendor/xiaomi/peridot-miuicamera
git clone https://github.com/peridot-hyperos-2/device_xiaomi_peridot-miuicamera device/xiaomi/peridot-miuicamera

# Hardware xiaomi (fresh clone)
echo "Cloning hardware xiaomi source..."
rm -rf hardware/xiaomi
git clone -b lineage-23.0 https://github.com/lightbulb-box/hardware_xiaomi.git hardware/xiaomi

# Dolby
git clone -b lineage-23.0 https://github.com/lightbulb-box/android_packages_apps_XiaomiDolby packages/apps/XiaomiDolby

# ViperFX
git clone https://github.com/TogoFire/packages_apps_ViPER4AndroidFX.git packages/apps/ViPER4AndroidFX

# Fix deprecated camera override flag
BOARD_CONFIG=device/xiaomi/peridot-miuicamera/BoardConfig.mk

if grep -q "TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED" "$BOARD_CONFIG"; then
    echo "[PATCH] Fixing deprecated TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED in $BOARD_CONFIG"

    sed -i '/TARGET_CAMERA_OVERRIDE_FORMAT_FROM_RESERVED/d' "$BOARD_CONFIG"

    echo '$(call soong_config_set,camera,override_format_from_reserved,true)' >> "$BOARD_CONFIG"
fi

echo "vendorsetup.sh execution complete."