import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView deviceInfoTextView = findViewById(R.id.deviceInfoTextView);

        String deviceInfo = "Manufacturer: " + Build.MANUFACTURER + "\n" +
                            "Model: " + Build.MODEL + "\n" +
                            "Android Version: " + Build.VERSION.RELEASE + "\n" +
                            "API Level: " + Build.VERSION.SDK_INT;

        deviceInfoTextView.setText(deviceInfo);
    }
}
