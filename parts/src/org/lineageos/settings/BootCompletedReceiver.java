package org.lineageos.settings.thermal;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import org.lineageos.settings.utils.FileUtils;

public class BootCompletedReceiver extends BroadcastReceiver {

    private static final String THERMAL_PROFILE_PATH = "/sys/class/thermal/thermal_message/sconfig";
    private static final String PREF_NAME = "thermal_profile_prefs";
    private static final String KEY_LAST_PROFILE = "last_profile";
    private static final int DEFAULT_PROFILE = 0;

    @Override
    public void onReceive(Context context, Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            SharedPreferences prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
            int lastProfile = prefs.getInt(KEY_LAST_PROFILE, DEFAULT_PROFILE);
            FileUtils.writeLine(THERMAL_PROFILE_PATH, lastProfile);
        }
    }
}
