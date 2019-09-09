package com.aptentity.borg_flutter;

import com.idlefish.flutterboost.containers.BoostFlutterActivity;

import java.util.Map;

public class FlutterActivity extends BoostFlutterActivity {
    @Override
    public Map getContainerUrlParams() {
        return null;
    }

    @Override
    public String getContainerUrl() {
        return "borg://secondPage";
    }
}
