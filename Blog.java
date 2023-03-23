import java.awt.*;
import java.awt.event.*;
import java.applet.Applet;
import javax.swing.*;

public class Blog extends JApplet {
    JButton TheYankeeszzISVERYCLEVER;

    public void init() {
        BlogLayout customLayout = new BlogLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        TheYankeeszzISVERYCLEVER = new JButton("http://pctechgreu.unaux.com/Vasiliy2.0/index.php/PC-Home-2-0-by-Vasiliy-PS/yankees-very-geeks");
        getContentPane().add(TheYankeeszzISVERYCLEVER);

        setSize(getPreferredSize());

    }

    public static void main(String args[]) {
        Blog applet = new Blog();
        JFrame window = new JFrame("Blog");

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

class BlogLayout implements LayoutManager {

    public BlogLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+0,insets.top+112,280,88);}
    }
}
