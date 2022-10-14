import java.awt.*;
import java.awt.event.*;
import java.applet.Applet;
import javax.swing.*;

public class webintoapp extends Applet {
    JButton webintoapp;

    public void init() {
        webintoappLayout customLayout = new webintoappLayout();

        setFont(new Font("Helvetica", Font.PLAIN, 12));
        setLayout(customLayout);

        webintoapp = new JButton("https://www.webintoapp.com/login");
        add(webintoapp);

        setSize(getPreferredSize());

    }

    public static void main(String args[]) {
        webintoapp applet = new webintoapp();
        Frame window = new Frame("webintoapp");

        window.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        applet.init();
        window.add("Center", applet);
        window.pack();
        window.setVisible(true);
    }
}

class webintoappLayout implements LayoutManager {

    public webintoappLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+64,insets.top+128,184,56);}
    }
}
