package com.parkmate

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.parkmate/whatsapp"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "shareFile") {
                val phone = call.argument<String>("phone")
                val filePath = call.argument<String>("filePath")
                val text = call.argument<String>("text")

                if (phone != null && filePath != null) {
                    shareFileToWhatsApp(phone, filePath, text)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENTS", "Phone or file path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun shareFileToWhatsApp(phone: String, filePath: String, text: String?) {
        val file = File(filePath)
        val uri = FileProvider.getUriForFile(this, "${applicationContext.packageName}.fileprovider", file)
        
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "image/*"
        intent.putExtra(Intent.EXTRA_STREAM, uri)
        intent.putExtra("jid", "$phone@s.whatsapp.net") // Target specific number
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        
        if (text != null) {
            intent.putExtra(Intent.EXTRA_TEXT, text)
        }

        // Check if WhatsApp is installed
        val pm = packageManager
        var whatsappPackage = "com.whatsapp"
        try {
            pm.getPackageInfo("com.whatsapp", 0)
        } catch (e: Exception) {
            try {
                pm.getPackageInfo("com.whatsapp.w4b", 0)
                whatsappPackage = "com.whatsapp.w4b"
            } catch (e: Exception) {
                // WhatsApp not installed, let the system handle it or fail
                whatsappPackage = ""
            }
        }

        if (whatsappPackage.isNotEmpty()) {
            intent.setPackage(whatsappPackage)
            try {
                startActivity(intent)
            } catch (e: Exception) {
                // Fallback to general share if specific targeting fails
                val fallbackIntent = Intent(Intent.ACTION_SEND)
                fallbackIntent.type = "image/*"
                fallbackIntent.putExtra(Intent.EXTRA_STREAM, uri)
                if (text != null) {
                    fallbackIntent.putExtra(Intent.EXTRA_TEXT, text)
                }
                fallbackIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                startActivity(Intent.createChooser(fallbackIntent, "Share Ticket"))
            }
        } else {
             // WhatsApp not found, throw error to trigger Dart fallback
             throw Exception("WhatsApp not installed")
        }
    }
}
