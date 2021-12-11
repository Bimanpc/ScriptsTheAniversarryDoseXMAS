import java.awt.*;
import java.awt.event.*;
import java.applet.Applet;
import javax.swing.*;

public class PDFDoctor extends JApplet {
    JButton PDFDoctor;
    JButton EDITPDFFORFREE&ONLINE!!;

    public void init() {
        PDFDoctorLayout customLayout = new PDFDoctorLayout();

        getContentPane().setFont(new Font("Helvetica", Font.PLAIN, 12));
        getContentPane().setLayout(customLayout);

        PDFDoctor = new JButton("https://pdfdoctor.com/");
        getContentPane().add(PDFDoctor);

        EDITPDFFORFREE&ONLINE!! = new JButton("https://pdfdoctor.com/");
        getContentPane().add(EDITPDFFORFREE&ONLINE!!);

        setSize(getPreferredSize());

    }

    public static void main(String args[]) {
        PDFDoctor applet = new PDFDoctor();
        JFrame window = new JFrame("PDFDoctor");

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

class PDFDoctorLayout implements LayoutManager {

    public PDFDoctorLayout() {
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
        if (c.isVisible()) {c.setBounds(insets.left+48,insets.top+136,208,56);}
        c = parent.getComponent(1);
        if (c.isVisible()) {c.setBounds(insets.left+80,insets.top+32,152,40);}
    }
}
