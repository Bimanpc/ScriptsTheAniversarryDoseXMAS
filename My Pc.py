from tkinter import *

win=Tk() #creating the main window and storing the window object in 'win'
win.geometry('200x100')
mb =  Menubutton ( win, text = 'Menu') 
mb.grid() 
mb.menu  =  Menu ( mb, tearoff = 0 ) 
mb['menu']  =  mb.menu

var1 = IntVar() 
var2 = IntVar() 
var3 = IntVar()

mb.menu.add_checkbutton ( label ='Home', variable = var1 ) 
mb.menu.add_checkbutton ( label = 'My Profile', variable = var2 ) 
mb.menu.add_checkbutton ( label = 'Sign Out', variable = var3 ) 
mb.pack() 


win.mainloop() #running the loop that works as a trigger
