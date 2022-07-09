import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class ZZZUA4ERVER extends JFrame {
    JButton ZZZHost!;
    JLabel ZZZHOSTUA!!!4EVER;

    public ZZZUA4ERVER() {
        ZZZUA4ERVERLayout customLayout = new ZZZUA4ERVERLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        ZZZHost! = new JButton("https://www.zzz.com.ua/en");
        getContentPane().add(ZZZHost!);

        ZZZHOSTUA!!!4EVER = new JLabel("https://www.zzz.com.ua/en");
        getContentPane().add(ZZZHOSTUA!!!4EVER);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        ZZZUA4ERVER window = new ZZZUA4ERVER();

        window.setTitle("ZZZUA4ERVER");
        window.pack();
        window.show();
    }
}

class ZZZUA4ERVERLayout implements LayoutManager {

    public ZZZUA4ERVERLayout() {
    }

    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public Dimension preferredLayoutSize(Container parent) {
        Dimension dim = new Dimension(0, 0);

        Insets insets = parent.getInsets();
        dim.width = 815 + insets.left + insets.right;
        dim.height = 497 + insets.top + insets.bottom;

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
        if (c.isVisible()) {c.setBounds(insets.left+184,insets.top+288,320,96);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+192,insets.top+184,312,104);}
    }
}
