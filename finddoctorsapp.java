import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class finddoctorsapp extends JFrame {
    JButton finddoctors.gov.gr;
    JLabel FindADR;

    public finddoctorsapp() {
        finddoctorsappLayout customLayout = new finddoctorsappLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        finddoctors.gov.gr = new JButton("finddoctors.gov.gr");
        getContentPane().add(finddoctors.gov.gr);

        FindADR = new JLabel("Find A Dr @ Gov.gr!!");
        getContentPane().add(FindADR);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        finddoctorsapp window = new finddoctorsapp();

        window.setTitle("finddoctorsapp");
        window.pack();
        window.show();
    }
}

class finddoctorsappLayout implements LayoutManager {

    public finddoctorsappLayout() {
    }

    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public Dimension preferredLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);

        Insets insets = parent.getInsets();
        dim.width = 430 + insets.left + insets.right;
        dim.height = 304 + insets.top + insets.bottom;

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
        if (c.isVisible()) {c.setBounds(insets.left+128,insets.top+200,168,48);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+144,insets.top+104,144,72);}
    }
}
