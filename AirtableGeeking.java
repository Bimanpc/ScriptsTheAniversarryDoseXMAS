import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class AirtableGeeking extends JFrame {
    JButton Airtable;
    JLabel AirtableGeeking;

    public AirtableGeeking() {
        AirtableGeekingLayout customLayout = new AirtableGeekingLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        Airtable = new JButton("https://airtable.com/");
        getContentPane().add(Airtable);

        AirtableGeeking = new JLabel("AirtableGeeking");
        getContentPane().add(AirtableGeeking);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        AirtableGeeking window = new AirtableGeeking();

        window.setTitle("AirtableGeeking");
        window.pack();
        window.show();
    }
}

class AirtableGeekingLayout implements LayoutManager {

    public AirtableGeekingLayout() {
    }

    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public Dimension preferredLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);

        Insets insets = parent.getInsets();
        dim.width = 320 + insets.left + insets.right;
        dim.height = 240 + insets.top + insets.bottom;

        return dim;
    }

    public Dimension minimumLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);
        return dim;
    }

    public void layoutContainer(Container parent) {
        Insets insets = parent.getInsets();

        Component c;
        c = parent.getComponent(0);
        if (c.isVisible()) {c.setBounds(insets.left+72,insets.top+144,136,24);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+72,120,40);}
    }
}
