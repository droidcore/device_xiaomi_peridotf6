package org.lineageos.settings.htsr;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.drawable.Icon;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;

import org.lineageos.settings.R;
import org.lineageos.settings.utils.FileUtils;

public class HtsrTileService extends TileService {

    private static final String HTSR_PATH = "/sys/devices/virtual/touch/touch_dev/bump_sample_rate";
    private static final String PREF_NAME = "htsr_prefs";
    private static final String KEY_LAST_STATE = "last_state";
    private static final int STATE_OFF = 0;
    private static final int STATE_ON = 1;

    private void saveState(int state) {
        SharedPreferences prefs = getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        prefs.edit().putInt(KEY_LAST_STATE, state).apply();
    }

    private int loadSavedState() {
        SharedPreferences prefs = getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return prefs.getInt(KEY_LAST_STATE, STATE_OFF);
    }

    private void applyState(int state) {
        FileUtils.writeLine(HTSR_PATH, state);
        saveState(state);
        updateUI(state);
    }

    private void updateUI(int state) {
        Tile tile = getQsTile();
        if (tile == null) return;

        tile.setLabel(getString(R.string.htsr_title));

        try {
            tile.setIcon(Icon.createWithResource(this, R.drawable.icon_htsr));
        } catch (Exception ignored) {}

        String subtitle;
        if (state == STATE_ON) {
            subtitle = getString(R.string.on);
            tile.setState(Tile.STATE_ACTIVE);
        } else if (state == STATE_OFF) {
            subtitle = getString(R.string.off);
            tile.setState(Tile.STATE_INACTIVE);
        } else {
            subtitle = getString(R.string.unknown);
            tile.setState(Tile.STATE_UNAVAILABLE);
        }

        tile.setSubtitle(subtitle);
        tile.updateTile();
    }

    @Override
    public void onStartListening() {
        super.onStartListening();
        int current = FileUtils.readLineInt(HTSR_PATH);
        if (current < 0) {
            current = loadSavedState();
            FileUtils.writeLine(HTSR_PATH, current);
        }
        updateUI(current);
    }

    @Override
    public void onClick() {
        super.onClick();

        int current = FileUtils.readLineInt(HTSR_PATH);
        if (current < 0) {
            current = loadSavedState();
        }

        int newState = (current == STATE_ON) ? STATE_OFF : STATE_ON;
        applyState(newState);
    }
}
