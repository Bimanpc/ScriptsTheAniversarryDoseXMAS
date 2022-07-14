import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class VPSFREE extends JFrame {
    JButton VPS;
    JLabel GeekIT;

    public VPSFREE() {
        VPSFREELayout customLayout = new VPSFREELayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        VPS = new JButton("ifreevps.com");
        getContentPane().add(VPS);

        GeekIT = new JLabel("vps 4 ever");
        getContentPane().add(GeekIT);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        VPSFREE window = new VPSFREE();

        window.setTitle("VPSFREE");
        window.pack();
        window.show();
    }
}

class VPSFREELayout implements LayoutManager {

    public VPSFREELayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+136,144,64);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+88,insets.top+88,128,48);}
    }
}
