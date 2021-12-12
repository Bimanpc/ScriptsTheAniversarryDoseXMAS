import java.awt.*;
import java.awt.event.*;
import java.applet.Applet;
import javax.swing.*;

public class MajorGeeks extends Applet {
    JButton GeeksAPP;
    JLabel MajorGeeks;

    public void init() {
        MajorGeeksLayout customLayout = new MajorGeeksLayout();

        setFont(new Font("Helvetica", Font.PLAIN, 12));
        setLayout(customLayout);

        GeeksAPP = new JButton("https://www.majorgeeks.com/");
        add(GeeksAPP);

        MajorGeeks = new JLabel("MajorGeeks Site ");
        add(MajorGeeks);

        setSize(getPreferredSize());

    }

    public static void main(String args[]) {
        MajorGeeks applet = new MajorGeeks();
        Frame window = new Frame("MajorGeeks");

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

class MajorGeeksLayout implements LayoutManager {

    public MajorGeeksLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+136,144,40);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+88,insets.top+40,144,56);}
    }
}
