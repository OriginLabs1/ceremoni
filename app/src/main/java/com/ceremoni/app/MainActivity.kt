package com.ceremoni.app
import android.app.Activity
import android.os.Bundle
import android.widget.TextView
import android.view.Gravity

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val textView = TextView(this)
        textView.text = "Ceremoni Sovereign Pipeline Verified"
        textView.gravity = Gravity.CENTER
        textView.setTextSize(24f)
        setContentView(textView)
    }
}
