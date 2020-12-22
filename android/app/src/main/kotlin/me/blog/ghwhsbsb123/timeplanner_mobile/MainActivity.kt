package me.blog.ghwhsbsb123.timeplanner_mobile

import android.content.ContentUris
import android.content.ContentValues
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "me.blog.ghwhsbsb123.timeplanner_mobile"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "writeImageAsBytes") {
                val fileName = call.argument<String>("fileName")
                val bytes = call.argument<ByteArray>("bytes")
                if (fileName != null && bytes != null) {
                    val path = writeImageAsBytes(fileName, bytes)
                    if (path != null) {
                        result.success(path)
                    } else {
                        result.error("ERROR", "Cannot write image bytes.", null)
                    }
                } else {
                    result.error("ERROR", "Invalid paramters.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun writeImageAsBytes(fileName: String, bytes: ByteArray): String? {
        val values = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.put(MediaStore.Images.Media.IS_PENDING, 1)
        }

        val contentResolver = getContentResolver()
        val projection = arrayOf(
            MediaStore.MediaColumns._ID,
            MediaStore.MediaColumns.DISPLAY_NAME,
            MediaStore.MediaColumns.RELATIVE_PATH,
            MediaStore.MediaColumns.DATE_MODIFIED
        )
        val selection = "${MediaStore.MediaColumns.RELATIVE_PATH}='${Environment.DIRECTORY_PICTURES}${File.separator}' AND ${MediaStore.MediaColumns.DISPLAY_NAME}='$fileName'"
        val c = contentResolver.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            projection, selection, null, null)
        var imageUri: Uri? = null

        if (c != null && c.count >= 1) {
            if (c.moveToFirst()) {
                val id = c.getLong(c.getColumnIndexOrThrow(MediaStore.MediaColumns._ID))
                imageUri = ContentUris.withAppendedId(
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id)
            }
        }

        val item = imageUri ?: contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)!!
        try {
            val pdf = contentResolver.openFileDescriptor(item, "w", null)
            if (pdf != null) {
                val fos = FileOutputStream(pdf.getFileDescriptor())
                fos.write(bytes)
                fos.close()

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    values.clear()
                    values.put(MediaStore.Images.Media.IS_PENDING, 0)
                    contentResolver.update(item, values, null, null)
                }

                val intent = Intent(Intent.ACTION_VIEW)
                intent.setDataAndType(item, "image/png")
                startActivity(intent)
                return item.path
            }
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return null
    }
}
