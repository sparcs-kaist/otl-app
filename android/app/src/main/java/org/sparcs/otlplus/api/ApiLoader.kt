package org.sparcs.otlplus.api

import android.content.Context
import okhttp3.*
import java.io.IOException
import java.util.concurrent.TimeUnit

class ApiLoader(context: Context) {
    private val cookies = Cookies(context)
    private val client = OkHttpClient.Builder()
        .connectTimeout(30, TimeUnit.SECONDS) // Connection timeout
        .readTimeout(30, TimeUnit.SECONDS)   // Read timeout
        .writeTimeout(30, TimeUnit.SECONDS)  // Write timeout
        .build()

    private val cookieHeader = cookies.header

    fun get(url: String, then: (String) -> Unit) {
        val request = Request.Builder()
            .url(url)
            .addHeader("Cookie", cookieHeader ?: "")
            .build()

        client.newCall(request).enqueue(object: Callback {
            override fun onFailure(call: Call, e: IOException) {
                println("FAILURE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                e.printStackTrace()
            }

            override fun onResponse(call: Call, response: Response) {
                println("GET RESPONSE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                then(response.body?.string() ?: "")
            }
        })
    }
}