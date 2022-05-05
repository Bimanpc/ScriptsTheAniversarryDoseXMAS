import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Cozyio extends JFrame {
    JButton button_1;
    JButton button_2;

    public Cozyio() {
        CozyioLayout customLayout = new CozyioLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        button_1 = new JButton("https://cozy.io/en/");
        getContentPane().add(button_1);

        button_2 = new JButton("Cozy The French Cloud");
        getContentPane().add(button_2);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        Cozyio window = new Cozyio();

        window.setTitle("Cozyio");
        window.pack();
        window.show();
    }
}

class CozyioLayout implements LayoutManager {

    public CozyioLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+64,insets.top+128,192,72);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+56,144,32);}
    }
}
