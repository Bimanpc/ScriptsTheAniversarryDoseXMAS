import java.awt.*;
import java.awt.event.*;
import java.applet.Applet;
import javax.swing.*;

public class FREERUHOST extends JApplet {
    JButton button_1;

    public void init() {
        FREERUHOSTLayout customLayout = new FREERUHOSTLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        button_1 = new JButton("??????????????.??");
        getContentPane().add(button_1);

        setSize(getPreferredSize());

    }

    public static void main(String args[]) {
        FREERUHOST applet = new FREERUHOST();
        JFrame window = new JFrame("FREERUHOST");

        window.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });

        applet.init();
        window.getContentPane().add("Center", applet);
        window.pack();
        window.setVisible(true);
    }
}

class FREERUHOSTLayout implements LayoutManager {

    public FREERUHOSTLayout() {
    }

    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public Dimension preferredLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);

        Insets insets = parent.getInsets();
        dim.width = 857 + insets.left + insets.right;
        dim.height = 595 + insets.top + insets.bottom;

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
        if (c.isVisible()) {c.setBounds(insets.left+144,insets.top+304,472,216);}
    }
}
