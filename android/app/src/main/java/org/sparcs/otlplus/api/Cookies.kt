package org.sparcs.otlplus.api

import android.content.Context

class Cookies(context: Context) {
    var header: String?
    var token: String?

    init {
        val sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        header = sharedPreferences.getString("flutter.cookie_header", null)
        token = sharedPreferences.getString("flutter.csrf_token", null)
    }
}