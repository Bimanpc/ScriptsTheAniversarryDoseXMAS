import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class onlinegdb extends JFrame {
    JButton onlinegdb.com;
    JLabel label_1;

    public onlinegdb() {
        onlinegdbLayout customLayout = new onlinegdbLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        onlinegdb.com = new JButton("onlinegdb.com");
        getContentPane().add(onlinegdb.com);

        label_1 = new JLabel("onlinegdb.com Make Code !");
        getContentPane().add(label_1);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        onlinegdb window = new onlinegdb();

        window.setTitle("onlinegdb");
        window.pack();
        window.show();
    }
}

class onlinegdbLayout implements LayoutManager {

    public onlinegdbLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+48,insets.top+112,152,56);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+64,insets.top+40,128,64);}
    }
}
