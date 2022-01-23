import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Jotform extends JFrame {
    JButton JotForm;
    JLabel label_1;

    public Jotform() {
        JotformLayout customLayout = new JotformLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        JotForm = new JButton("https://www.jotform.com/");
        getContentPane().add(JotForm);

        label_1 = new JLabel("JotForm The Free Form");
        getContentPane().add(label_1);

        setSize(getPreferredSize());

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void main(String args[]) {
        Jotform window = new Jotform();

        window.setTitle("Jotform");
        window.pack();
        window.show();
    }
}

class JotformLayout implements LayoutManager {

    public JotformLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+152,144,40);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+120,insets.top+80,72,24);}
    }
}
