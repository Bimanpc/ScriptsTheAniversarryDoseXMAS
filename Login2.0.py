from tkinter import *

win=Tk() #creating the main window and storing the window object in 'win'
win.geometry('300x200') #setting the size of the window


Label(win, text='Name').grid(row=0) 

Label(win, text='Email or Phone').grid(row=1) 

ent1 = Entry(win) 

ent2 = Entry(win) 

ent1.grid(row=0, column=1) 

ent2.grid(row=1, column=1) 
mainloop() 
