package ninja.mirea.mireaapp;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import android.widget.RemoteViews;
import ninja.mirea.mireaapp.widget_channel.AbstractHomeWidgetProvider
import ninja.mirea.mireaapp.widget_channel.HomeWidgetBackgroundIntent
import ninja.mirea.mireaapp.widget_channel.HomeWidgetLaunchIntent

import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonElement
import ninja.mirea.mireaapp.widget_channel.ScheduleModel

class HomeWidgetProvider : AbstractHomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.timetable_layout).apply {
                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                val scheduleData = widgetData.getString("schedule", "")
                if (scheduleData!!.isNotEmpty()){
                    val scheduleModel = Json.decodeFromString(ScheduleModel.serializer(),scheduleData);

                }
//                setRemoteAdapter()

                // Swap Title Text by calling Dart Code in the Background
                setTextViewText(
                    R.id.widget_title, widgetData.getString("title", null)
                        ?: "No Title Set"
                )
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidgetExample://titleClicked")
                )
                setOnClickPendingIntent(R.id.widget_title, backgroundIntent)

//                val message = widgetData.getString("testString", null)
//                setTextViewText(
//                    R.id.widget_message, message
//                        ?: "No Message Set"
//                )
                // Detect App opened via Click inside Flutter
//                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
//                    context,
//                    MainActivity::class.java,
//                    Uri.parse("homeWidgetExample://message?message=$message")
//                )
//                setOnClickPendingIntent(R.id.widget_message, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
