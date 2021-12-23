import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class pFormXMAS extends JFrame {
    JButton pForm;
    JLabel pform;

    public pFormXMAS() {
        pFormXMASLayout customLayout = new pFormXMASLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        pForm = new JButton("http://www.phpform.org/");
        getContentPane().add(pForm);

        pform = new JLabel("Create HTML Form in Seconds");
        getContentPane().add(pform);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        pFormXMAS window = new pFormXMAS();

        window.setTitle("pFormXMAS");
        window.pack();
        window.show();
    }
}

class pFormXMASLayout implements LayoutManager {

    public pFormXMASLayout() {
    }

    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public Dimension preferredLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);

        Insets insets = parent.getInsets();
        dim.width = 725 + insets.left + insets.right;
        dim.height = 492 + insets.top + insets.bottom;

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
        if (c.isVisible()) {c.setBounds(insets.left+192,insets.top+256,312,112);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+200,insets.top+96,280,120);}
    }
}
