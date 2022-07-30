import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Aternos extends JFrame {
    JButton Aternos;

    public Aternos() {
        AternosLayout customLayout = new AternosLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        Aternos = new JButton("https://aternos.org/go/");
        getContentPane().add(Aternos);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        Aternos window = new Aternos();

        window.setTitle("Aternos");
        window.pack();
        window.show();
    }
}

class AternosLayout implements LayoutManager {

    public AternosLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+72,insets.top+96,176,88);}
    }
}
